-- Simulations for the tips and tricks entries (see data.lua).
--
-- The init code runs as a console command inside the simulation, so it can't
-- use require. Anything that needs the mod's own runtime behavior (hidden
-- helper entities, heat from the supercomputer) lists Solar-Halo under `mods`
-- and creates its entities with raise_built, so the real control scripts do
-- that work instead of this file copying it.
local simulations = {}

-- Solar flares drifting past a platform: a gun turret can't hurt them, a laser
-- turret can. The two turrets sit far enough apart that each flare is only
-- ever inside the range of one of them (gun turret 18, laser turret 24).
simulations.solar_halo_briefing =
{
  init_update_count = 400,
  mute_wind_sounds = false,
  hide_health_bars = false,
  checkboard = false,
  init =
  [==[
    local force = game.forces.player
    storage.platform = force.create_space_platform{name = "platform", planet = "nauvis", starter_pack = "space-platform-starter-pack"}
    storage.platform.apply_starter_pack()
    local surface = storage.platform.surface
    storage.surface = surface

    game.simulation.camera_surface_index = surface.index
    game.simulation.camera_position = {0, 0}
    game.simulation.camera_zoom = 0.5
    game.simulation.hide_cursor = true

    local tiles = {}
    for x = -20, 19 do
      for y = -5, 4 do
        table.insert(tiles, {position = {x, y}, name = "space-platform-foundation"})
      end
    end
    surface.set_tiles(tiles)

    -- laser damage upgrades, so a flare dies before it drifts out of range
    force.set_turret_attack_modifier("laser-turret", 3)

    local gun = surface.create_entity{name = "gun-turret", position = {-16, -1}, force = force}
    gun.insert{name = "firearm-magazine", count = 200}

    local laser = surface.create_entity{name = "laser-turret", position = {16, -1}, force = force}
    surface.create_entity{name = "medium-electric-pole", position = {13.5, 1.5}, force = force}
    local source = surface.create_entity{name = "electric-energy-interface", position = {11, -1}, force = force}
    source.power_production = 20000000 / 60

    -- a flare down each side, one after the other. The lanes are outside the
    -- platform, within reach of one turret and out of reach of the other.
    local speed = 0.05
    local lanes = {{x = -24, y = -26}, {x = 24, y = -26}}
    local function spawn(lane)
      storage.surface.create_entity{name = "halo-flare", position = {lane.x, lane.y}, velocity = {0, speed}}
    end
    spawn(lanes[1])

    script.on_nth_tick(30, function(event)
      local phase = event.tick % 900
      if phase == 0 then spawn(lanes[1]) end
      if phase == 450 then spawn(lanes[2]) end
      for _, flare in pairs(storage.surface.find_entities_filtered{name = "halo-flare"}) do
        if flare.position.y > 40 then flare.destroy() end
      end
    end)
  ]==]
}

-- The permanent station: a disc of station foundation on lava, with power
-- coming from the foundation itself.
simulations.solar_station_briefing =
{
  init_update_count = 60,
  planet = "halo-solar-station",
  mute_wind_sounds = false,
  checkboard = false,
  init =
  [==[
    local surface = game.surfaces[1]
    game.simulation.camera_position = {0, 0}
    game.simulation.camera_zoom = 0.75
    game.simulation.camera_alt_info = true
    game.simulation.hide_cursor = true

    surface.daytime = 0.5
    surface.freeze_daytime = true

    local tiles = {}
    for x = -24, 23 do
      for y = -16, 15 do
        local distance = math.sqrt((x + 0.5) ^ 2 + (y + 0.5) ^ 2)
        table.insert(tiles, {position = {x, y}, name = distance < 7 and "halo-foundation" or "halo-empty-space"})
      end
    end
    surface.set_tiles(tiles)

    -- every foundation tile adds to the surface's power, which is shared
    -- everywhere on the surface without poles
    surface.create_global_electric_network()
    local energy = surface.create_entity{name = "halo-station-energy", position = {0, 0}, force = "player"}
    energy.power_production = 800000000
    energy.electric_buffer_size = 800000000 / 60

    local force = game.forces.player
    surface.create_entity{name = "cargo-landing-pad", position = {0, 0}, force = force}
    for _, position in pairs({{-5, -4}, {5, -4}, {-5, 4}, {5, 4}, {0, -5}, {0, 5}}) do
      local lamp = surface.create_entity{name = "small-lamp", position = position, force = force}
      lamp.always_on = true
    end

    -- the station grows by laying more foundation along its edge
    for x = 7, 10 do
      for y = -3, 3 do
        surface.create_entity{name = "tile-ghost", ghost_name = "halo-foundation", position = {x, y}, force = force}
      end
    end
  ]==]
}

-- A supercomputer heating up, with a heat pipe leading its heat to a
-- heatsink that is venting it.
simulations.halo_overheating =
{
  init_update_count = 900,
  mods = {"Solar-Halo"},
  mute_wind_sounds = false,
  init =
  [==[
    local surface = game.surfaces[1]
    local force = game.forces.player
    game.simulation.camera_position = {-1, 1}
    game.simulation.camera_zoom = 0.8
    game.simulation.camera_alt_info = true
    game.simulation.hide_cursor = true

    force.recipes["halo-compute"].enabled = true
    force.recipes["halo-heatsink-low"].enabled = true

    local source = surface.create_entity{name = "electric-energy-interface", position = {-15, 0}, force = force}
    source.power_production = 2000000000 / 60
    surface.create_entity{name = "medium-electric-pole", position = {-12.5, 0.5}, force = force}

    local computer = surface.create_entity{name = "halo-computer", position = {-8, 0}, force = force, raise_built = true}
    computer.set_recipe("halo-compute")

    -- the compute the computer makes goes into a drain
    local drain = surface.create_entity{name = "infinity-pipe", position = {-7.5, -2.5}, force = force}
    drain.set_infinity_pipe_filter{name = "halo-compute", percentage = 0, mode = "exactly"}

    -- heat pipes along the computer's south east corner, reaching the heatsink
    for x = -5.5, 2.5 do
      surface.create_entity{name = "heat-pipe", position = {x, 1.5}, force = force}
    end

    local heatsink = surface.create_entity{name = "halo-heatsink", position = {4.5, 2.5}, force = force, raise_built = true}
    heatsink.set_recipe("halo-heatsink-low")

    -- Start close to the limit and let the first seconds run before the tip
    -- is shown, so it opens on the heatsink working and the computer holding
    -- itself around 200 degrees, stopping whenever it gets too hot.
    local reactor = surface.find_entities_filtered{name = "halo-computer-heat"}[1]
    if reactor then reactor.temperature = 180 end
  ]==]
}

return simulations
