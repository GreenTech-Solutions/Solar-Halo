local function mapgen()
	local mg = {
		property_expression_names = {
			-- TODO: `halo_platform` is never defined anywhere in this mod, so this
			-- evaluates to nil and the key is dropped: no elevation expression is
			-- actually set here. Either define a real noise expression and reference
			-- it by name (string), or remove this line.
			elevation = halo_platform,
		},
		autoplace_settings = {
			["tile"] = {
				settings = {
					["halo-foundation"] = {},
					["halo-empty-space"] = {},
		}}}
	}
	return mg
end

data:extend{{
	type = "planet",
	name = "halo-solar-station",
	persistent_ambient_sounds = {
		base_ambience = {filename = "__space-age__/sound/wind/wind-space-platform.ogg", volume = 0.8},
		wind = {filename = "__space-age__/sound/wind/wind-space-platform.ogg", volume = 0.2},
		crossfade = {
			order = {"wind", "base_ambience"},
			curve_type = "cosine",
			from = {control = 0.35, volume_percentage = 0.0},
			to = {control = 2, volume_percentage = 100.0}
		},
		semi_persistent = {
			sound = {variations = sound_variations("__space-age__/sound/world/semi-persistent/distant-thunder", 4, 0.6)},
			delay_mean_seconds = 33,
			delay_variance_seconds = 7
		}
	},
	surface_render_parameters = {
		day_night_cycle_color_lookup = {{
			0, "identity"
		},{
			0.5, "__Solar-Halo__/space/lut.png"
		}},
		terrain_tint_effect = {
			noise_texture = {
				filename = "__space-age__/graphics/terrain/vulcanus/tint-noise.png",
				size = 4096
			},

			offset = { 0.2, 0, 0.4, 0.8 },
			intensity = { 0.1, 0.1, 0.1, 1.0 },
			scale_u = { 3, 1, 1, 1 },
			scale_v = { 1, 1, 1, 1 },

			global_intensity = 0.1,
			global_scale = 0.1,
			zoom_factor = 3,
			zoom_intensity = 0.6,
		},
		shadow_opacity = 0.0,
	},
	map_gen_settings = mapgen(),
	surface_properties = {
		["day-night-cycle"] = 2,
        ["magnetic-field"] = 99,
        ["solar-power"] = 200000,
        pressure = 1,
        gravity = 1,
    },
	solar_power_multiplier = 0,
	order = "aa",
	subgroup = "planets",
	gravity_pull = 150,
	distance = 2.5,
	orientation = 0.125,
	draw_orbit = false,
	solar_power_in_space = 20000,
	icons = {{
		icon = "__Solar-Halo__/space/solarorbit.png",
		icon_size = 128,
	},{
		icon = "__Solar-Halo__/space/station-foundation.png",
		scale = 0.36
	}},
	starmap_icon = "__Solar-Halo__/blank.png",
	starmap_icon_size = 1,
	fly_condition = false,
	asteroid_spawn_definitions = {{
		asteroid = "halo-flare",
		probability = 0.02,
		speed = 10 * meter/second,
	}},
},{
	type = "space-location",
	name = "halo-solar-orbit",
	order = "ab",
	subgroup = "planets",
	gravity_pull = 150,
	distance = 4,
	orientation = 0.125,
	solar_power_in_space = 20000,
	icon = "__Solar-Halo__/space/solarorbit.png",
	icon_size = 128,
	starmap_icon = "__Solar-Halo__/blank.png",
	starmap_icon_size = 1,
	fly_condition = true,
	auto_save_on_first_trip = true,
	asteroid_spawn_definitions = {{
		asteroid = "halo-flare",
		probability = 0.02,
		speed = 10 * meter/second,
	}},
},{
	type = "space-connection",
	name = "vulcanus-solar",
	subgroup = "planet-connections",
	order = "ab",
	from = "vulcanus",
	to = "halo-solar-orbit",
	length = 30000,
	icons = {{
			icon = "__space-age__/graphics/icons/planet-route.png" 
		},{
			icon = "__space-age__/graphics/icons/vulcanus.png",
			icon_size = 64,
			scale = 0.36,
			shift = {-7, -7}
		},{
			icon = "__Solar-Halo__/space/solarorbit.png",
			icon_size = 128,
			scale = 0.36 * (64 / 128),
			shift = {8, 8},
			tint = {0, 0, 0, 0.3}
		},{
			icon = "__Solar-Halo__/space/solarorbit.png",
			icon_size = 128,
			scale = 0.38 * (64 / 128),
			shift = {6, 6}
	}},
	asteroid_spawn_definitions = {{
		asteroid = "halo-flare",
		spawn_points = {{
			distance = 0.1,
			probability = 0.0001,
			speed = 2 * meter/second,
			angle_when_stopped = 0,
		},{
			distance = 0.3,
			probability = 0.005,
			speed = 4 * meter/second,
			angle_when_stopped = 0,
		},{
			distance = 0.5,
			probability = 0.01,
			speed = 5 * meter/second,
			angle_when_stopped = 0,
		},{
			distance = 0.7,
			probability = 0.015,
			speed = 6 * meter/second,
			angle_when_stopped = 0,
		},{
			distance = 0.9,
			probability = 0.02,
			speed = 7 * meter/second,
			angle_when_stopped = 0,
		}},
	}},
},{
	type = "space-connection",
	name = "solar-station",
	subgroup = "planet-connections",
	order = "aa",
	from = "halo-solar-orbit",
	to = "halo-solar-station",
	length = 1,
	icons = {{
			icon = "__space-age__/graphics/icons/planet-route.png" 
		},{
			icon = "__Solar-Halo__/space/solarorbit.png",
			icon_size = 64,
			scale = 0.36,
			shift = {-7, -7}
		},{
			icon = "__Solar-Halo__/space/station-foundation.png",
			scale = 0.36 * (64 / 128),
			shift = {8, 8},
			tint = {0, 0, 0, 0.3}
		},{
			icon = "__Solar-Halo__/space/station-foundation.png",
			scale = 0.38 * (64 / 128),
			shift = {6, 6}
	}},
	asteroid_spawn_definitions = {},
},{
	type = "asteroid",
	name = "halo-flare",
	subgroup = "space-environment",
	order = "zz",
	mass = 100000,
	graphics_set = {
		rotation_speed = 0.05,
		specular_strength = 0,
		normal_strength = 0,
		sss_amount = 0,
		brightness = 1,
		ambient_light = {1,1,1,1},

		lights = {
			color = {1,1,1,1},
			direction = {0,0,-1},
		},
		variations = {{
			color_texture = {
				filename = "__Solar-Halo__/space/flare.png",
				width = 256,
				height = 256,
				scale = 0.5,
			},
			normal_map = {
				filename = "__Solar-Halo__/space/normal.png",
				width = 1,
				height = 1,
				scale = 128,
			},
			roughness_map = {
				filename = "__Solar-Halo__/space/roughness.png",
				width = 1,
				height = 1,
				scale = 128,
			},
		}},
	},
	max_health = 500,
	resistances = {
		{type = "physical", decrease = 0, percent = 99},
		{type = "explosion", decrease = 0, percent = 95},
		{type = "laser", decrease = 0, percent = 50},
	},
	create_ghost_on_death = false,
	icon = "__Solar-Halo__/space/flare.png",
	icon_size = 256,
	collision_box = {{-1.5, -1.5}, {1.5, 1.5}},
	selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
},{	
	type = "noise-expression",
	name = "halo_station",
	expression = "distance < 7"
},{
	type = "electric-energy-interface",
	name = "halo-station-energy",
	hidden = true,
	collision_mask = {layers = {}},
	collision_box = {{-0.0, -0.0}, {0.0, 0.0}},
	selection_box = {{-0.0, -0.0}, {0.0, 0.0}},
	icon = "__base__/graphics/icons/solar-panel.png",
	flags = {"not-on-map", "not-deconstructable", "not-blueprintable", "hide-alt-info", "not-flammable", "placeable-off-grid" },
	energy_source = {
		type = "electric",
		buffer_capacity = "10MJ",
		usage_priority = "primary-output",
	},
	energy_production = "800MW",
	energy_usage = "0W",
	selectable_in_game = false
},{
	type = "tile",
	name = "halo-foundation",
	subgroup = "artificial-tiles",
	order = "zz",
	collision_mask = {
		layers = {
		}
	},
	layer = 15,
	variants = data.raw["tile"]["space-platform-foundation"].variants,
	transitions = data.raw["tile"]["foundation"].transitions,
    transitions_between_transitions = data.raw["tile"]["foundation"].transitions_between_transitions,
	map_color = data.raw["tile"]["space-platform-foundation"].map_color,
	icon = data.raw["tile"]["space-platform-foundation"].icon,
	landing_step_sounds = data.raw["tile"]["space-platform-foundation"].landing_step_sounds,
	driving_sound = data.raw["tile"]["space-platform-foundation"].driving_sound,
	build_sound = data.raw["tile"]["space-platform-foundation"].build_sound,
	mined_sound = data.raw["tile"]["space-platform-foundation"].mined_sound,
	minable = {
		mining_time = 0.5,
		result = "halo-foundation",
		count = 1,
	},
	placeable_by = {
		item = "halo-foundation",
		count = 1,
	},
	autoplace = {
		probability_expression = "halo_station",
	},
},{
	type = "item",
	name = "halo-foundation",
	subgroup = "terrain",
	order = "zz",
	stack_size = 50,
	icons = {{
		icon = "__Solar-Halo__/space/station-foundation.png" 
	},{
		icon = "__base__/graphics/icons/solar-panel.png",
		scale = 0.38 * (64 / 128),
		shift = {6, 6}
	}},
	open_sound = data.raw["item"]["space-platform-foundation"].open_sound,
	close_sound = data.raw["item"]["space-platform-foundation"].close_sound,
	pick_sound = data.raw["item"]["space-platform-foundation"].pick_sound,
	drop_sound = data.raw["item"]["space-platform-foundation"].drop_sound,
	inventory_move_sound = data.raw["item"]["space-platform-foundation"].inventory_move_sound,
	place_as_tile = {
		result = "halo-foundation",
		condition = {layers = {}},
		condition_size = 0,
		tile_condition = {"halo-empty-space"},
	},
},{
	type = "recipe",
	name = "halo-foundation",
	enabled = false,
	energy_required = 2,
	ingredients = {
		{type = "item", name = "foundation", amount = 9},
		{type = "item", name = "space-platform-foundation", amount = 9},
		{type = "item", name = "solar-panel", amount = 1}
	},
	results = {{type = "item", name = "halo-foundation", amount = 9}}
}}

data.raw["tile"]["halo-foundation"].variants = data.raw["tile"]["foundation"].variants
data.raw["tile"]["halo-foundation"].variants.main = data.raw["tile"]["space-platform-foundation"].variants.main
data.raw["tile"]["halo-foundation"].variants.material_background = data.raw["tile"]["space-platform-foundation"].variants.material_background
data.raw["tile"]["halo-foundation"].transitions[1].spritesheet = "__Solar-Halo__/space/transitions.png"
data.raw["tile"]["halo-foundation"].transitions_between_transitions[1].spritesheet = "__Solar-Halo__/space/transitions.png"



local halospace = table.deepcopy(data.raw["tile"]["lava-hot"])
halospace.name = "halo-empty-space"
halospace.autoplace = {probability_expression = "halo_station < 1"}
halospace.placeable_by = {item = "halo-foundation", count = 1}
halospace.default_cover_tile = "halo-foundation"
halospace.collision_mask = {
  layers = {
    water_tile=true,
    player=true,
    lava_tile=true,
    rail=true,
	elevated_rail=true,
  }
}
halospace.layer_group = "zero"
halospace.layer = 0
halospace.fluid = nil
halospace.allowed_neighbors={"halo-foundation"}
halospace.map_color = {r = 255, g = 255, b = 50}
halospace.absorptions_per_second = nil
halospace.ambient_sounds = nil
halospace.effect_color = { 255, 255, 50 }
halospace.effect_color_secondary = { 255, 255, 50 }
-- Vulcanus' lava shader (two noise layers that flow into each other, which
-- repeats less obviously than the plain water effect), as a copy so the
-- vanilla lava is untouched. Multipliers are relative to the vanilla lava
-- values. The shader's parameters live in `solar_effect.water` even though it
-- is the lava variation. Other things to try, if needed: `scale` (size of
-- the pattern, x and y separately), and the dark/reflection/specular
-- thresholds, which are cutoffs on the noise that decide where the dark
-- patches, reflections and glints show up.
local flow = {
	speed = 3,
	tick = 1.8,
	scale = {0.08, 0.03},
}
local solar_effect = table.deepcopy(data.raw["tile-effect"]["lava"])
solar_effect.name = "halo-solar"
solar_effect.water.animation_speed = solar_effect.water.animation_speed * flow.speed
solar_effect.water.tick_scale = solar_effect.water.tick_scale * flow.tick
solar_effect.water.animation_scale = flow.scale
-- Vulcanus' lava is orange because its texture is orange, so the tint can't
-- fix that: the second texture is a recolored copy (made by
-- tools/recolor-lava.py), and the shader's own highlight colors, a green and a
-- brown in Vulcanus' lava, are moved to yellow.
-- 2.1.22 moved the lava image from textures[2] to image_textures[1].
local water = solar_effect.water
local lava = water.image_textures and water.image_textures[1] or water.textures[2]
lava.filename = "__Solar-Halo__/space/lava-solar.png"
solar_effect.water.specular_lightness = {48, 40, 6}
solar_effect.water.foam_color = {70, 55, 12}
data:extend{solar_effect}
halospace.effect = "halo-solar"
halospace.variants.main[1].picture = "__Solar-Halo__/space/solar-tile.png"
data.extend{halospace}
