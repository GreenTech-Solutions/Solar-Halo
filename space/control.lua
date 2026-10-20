-- space/control.lua

local M = {}

function M.ensure_storage()
	storage["solar-surface"] = storage["solar-surface"] or {}
	storage["solar-forces"] = storage["solar-forces"] or {}
end

function M.ensure_solar_station_power()
	if storage["solar-station"] == nil or not storage["solar-station"].valid then
		local surface = game.get_surface("halo-solar-station")
		if surface then
			local e = surface.create_entity {
				name = "halo-station-energy",
				position = {0, 0},
				force = "player",
			}
			e.destructible = false
			e.minable_flag = false
			local p = 800000000
			e.power_production = p
			e.electric_buffer_size = p / 60
			storage["solar-station"] = e
		end
	end
end

----------surface----------
script.on_event({
	defines.events.on_surface_created,
	defines.events.on_surface_imported},
function(event)
	local s = game.get_surface(event.surface_index)
	if s and s.name == "halo-solar-station" then
		s.create_global_electric_network()
		s.solar_power_multiplier = 0
		M.ensure_solar_station_power()
		s.daytime = 0.5
		s.freeze_daytime = true
	end
end)

script.on_event({
	defines.events.on_surface_deleted,
	defines.events.on_surface_cleared},
function(event)
	local s = game.get_surface(event.surface_index)
	if s and s.name == "halo-solar-station" then
		M.ensure_solar_station_power()
	end
end)

----------tile created---------
script.on_event({
	defines.events.on_player_built_tile,
	defines.events.on_robot_built_tile},
function(event)
	local s = game.get_surface(event.surface_index)
	if s.name == "halo-solar-station" then
		M.ensure_solar_station_power()
		local p = storage["solar-station"].power_production
		p = p + 13000000 * #event.tiles
		storage["solar-station"].power_production = p
		storage["solar-station"].electric_buffer_size = p / 60
	end
end)

---------tile removed---------
script.on_event({
	defines.events.on_player_mined_tile,
	defines.events.on_robot_mined_tile},
function(event)
	local s = game.get_surface(event.surface_index)
	if s.name == "halo-solar-station" then
		local p = storage["solar-station"].power_production
		for _, tile in pairs(event.tiles) do
			if tile.old_tile.name == "halo-foundation" then p = p - 13000000 end
		end
		storage["solar-station"].power_production = p
		storage["solar-station"].electric_buffer_size = p / 60
	end
end)

----------Solar Productivity----------
local function updateSolar()
	local m = 0
	for _, lvl in pairs(storage["solar-forces"]) do
		if lvl > m then m = lvl end
	end

	for _, s in pairs(game.surfaces) do
		if storage["solar-surface"] == nil then
			storage["solar-surface"] = {}
		end
		if storage["solar-surface"][s.name] == nil then
			storage["solar-surface"][s.name] = s.solar_power_multiplier
		end
		local solar = storage["solar-surface"][s.name]
		if solar > 0 then
			local bonus = solar * 0.1 * m
			s.solar_power_multiplier = solar + bonus
		end
	end
end

script.on_event(defines.events.on_research_finished, function(event)
	if event.research.name == "halo-solar" then
		if storage["solar-forces"] == nil then
			storage["solar-forces"] = {}
		end

		storage["solar-forces"][event.research.force.name] = event.research.level - 1

		updateSolar()
	end
end)

script.on_event(defines.events.on_research_reversed, function(event)
	if event.research.name == "halo-solar" then
		if storage["solar-forces"] == nil then
			storage["solar-forces"] = {}
		end
		storage["solar-forces"][event.research.force.name] = 0
		updateSolar()
	end
end)

return M
