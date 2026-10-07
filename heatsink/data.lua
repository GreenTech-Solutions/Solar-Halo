local util = require("halo-util")

-- The superheated pipe used to be a plain "heat-pipe" item whose place_result
-- was never overridden away from the vanilla heat-pipe entity, so both the
-- vanilla "heat-pipe" item and this item could build the exact same entity.
-- That ambiguity is what let the game's ghost/robot item-resolution (used by
-- remote view and construction bots, but not by hand-placement or the editor)
-- pick "halo-superheated-pipe" to satisfy a plain heat-pipe ghost -- a
-- hidden/uncraftable item nobody actually has, so the ghost could never be
-- fulfilled. Giving it its own entity removes the ambiguity entirely: only
-- "heat-pipe" can ever build "heat-pipe", and only "halo-superheated-pipe"
-- can ever build "halo-superheated-pipe".
-- (initial temperature is set to 800 on build in control.lua, rather than via
-- heat_buffer.default_temperature -- raising default_temperature past the
-- default min_working_temperature would also require raising
-- min_working_temperature to match, and it's unclear whether that has other
-- side effects on a bare heat-pipe, so setting it explicitly on build is the
-- safer option)
local shp_entity = table.deepcopy(data.raw["heat-pipe"]["heat-pipe"])
shp_entity.name = "halo-superheated-pipe"
-- Once placed it's just a heat pipe, so it reads as one everywhere the entity
-- is shown (tooltips, ghosts, alt-mode, factoriopedia).
shp_entity.localised_name = {"entity-name.heat-pipe"}
shp_entity.localised_description = {"entity-description.heat-pipe"}
data:extend{shp_entity}

local shpipe = table.deepcopy(data.raw["item"]["heat-pipe"])
shpipe.icons = {{
	icon = "__Solar-Halo__/heatsink/shp-glow.png"
},{
	icon = shpipe.icon,
	size = shpipe.icon_size
}}
shpipe.icon = nil
shpipe.name = "halo-superheated-pipe"
shpipe.place_result = "halo-superheated-pipe"
-- Set explicitly: an item with a place_result otherwise takes its name and
-- description from the entity it places, which deliberately reads as a plain
-- "Heat pipe" (see above), so the item would lose the "Superheated" label.
shpipe.localised_name = {"item-name.halo-superheated-pipe"}
shpipe.localised_description = {"item-description.halo-superheated-pipe"}
shpipe.fuel_category = "chemical"
shpipe.burnt_result = "heat-pipe"
shpipe.fuel_value = "350MJ"
shpipe.fuel_emissions_multiplier = 0
shpipe.order = shpipe.order .. "1"
shpipe.hide_from_player_crafting = true
shpipe.auto_recycle = false
data:extend{shpipe}


data:extend{{
	type = "assembling-machine",
	name = "halo-heatsink",
	icon = "__Solar-Halo__/heatsink/icon.png",
	fluid_boxes_off_when_no_fluid_recipe = false,
	energy_source = {type = "void"},
	energy_usage = "1W",
	crafting_speed = 1,
	crafting_categories = {"halo-heatsink"},
    damaged_trigger_effect = util.hit_effects.entity(),
	fluid_boxes = {{
			volume = 1000,
			pipe_connections = {{
				connection_type = "linked",
				linked_connection_id = 1
			}},
			production_type = "input"
		},{
			volume = 1000,
			pipe_connections = {{
				connection_type = "linked",
				linked_connection_id = 2
			}},
			production_type = "input"
		},{
			pipe_picture = util.pipe_picture,
			pipe_picture_frozen = util.pipe_frozen,
			pipe_covers = util.pipecoverspictures(),
			secondary_draw_order = -1,
			volume = 200,
			pipe_connections = {{
				direction = defines.direction.west,
				position = { x = -1.1, y = 0 }
			},{
				direction = defines.direction.east,
				position = { x = 1.1, y = 0 }
			}}, 
			production_type = "input"
		},{
			pipe_picture = util.pipe_picture,
			pipe_picture_frozen = util.pipe_frozen,
			pipe_covers = util.pipecoverspictures(),
			secondary_draw_order = -1,
			volume = 100,
			pipe_connections = {{
				direction = defines.direction.north,
				position = { x = 0, y = -1.1 },
			},{
				direction = defines.direction.south,
				position = { x = 0, y = 1.1 },
			}},
			production_type = "output"
		}
	},
    corpse = "assembling-machine-1-remnants",
    dying_explosion = "heat-exchanger-explosion",
    open_sound = util.sounds.steam_open,
    close_sound = util.sounds.steam_close,
	working_sound = {
		sound = {
			filename = "__base__/sound/heat-exchanger.ogg",
			volume = 0.65,
			modifiers = volume_multiplier("main-menu", 0.7),
			audible_distance_modifier = 0.5,
		},
		fade_in_ticks = 4,
		fade_out_ticks = 20
	},
	circuit_wire_max_distance = 12,
	max_health = 300,
	collision_box = {{-1.45,-1.45}, {1.45,1.45}},
	selection_box = {{-1.5,-1.5}, {1.5,1.5}},
	flags = {"player-creation"},
	minable = {
		mining_time = 0.1,
		result = "halo-heatsink"
	},
	placeable_by = {item = "halo-heatsink", count = 1},
	tile_width = 3,
	tile_height = 3,
	graphics_set = {
		animation = {
			filename = "__Solar-Halo__/heatsink/animation.png",
			width = 350,
			height = 324,
			frame_count = 1,
			line_length = 1,
			scale = 0.42,
			shift = {.42, -.15},
		},
	},
},{
	type = "assembling-machine",
	fixed_recipe = "halo-heatsinkreceiverlow",
	crafting_speed = 1,
	crafting_categories = {"halo-heatpump"},
	energy_source = {
		type = "heat",
		max_temperature = 999,
		specific_heat = "3MJ",
		max_transfer = "500MW",
		min_working_temperature = 160,
		-- Owns all 4 external corners (previously split 2-and-2 with
		-- halo-heatsinkhighreceiver, as two independently-heated networks --
		-- see the last connection below for why that was a problem) plus one
		-- extra internal connection south, to an ordinary adjacent heat
		-- connection one tile further south on halo-heatsinkhighreceiver
		-- (which is co-located with this entity, see below). This makes
		-- both receivers part of the exact same heat network -- reaching a
		-- real, shared equilibrium temperature by ordinary heat conduction --
		-- while keeping their fluid outputs completely separate, so there's
		-- no fluid-temperature averaging between the low and high streams.
		connections = {{
			position = {x = -1.1, y = -1.1},
			direction = defines.direction.north
		},{
			position = {x = -1.1, y = -1.1},
			direction = defines.direction.west
		},{
			position = {x = 1.1, y = 1.1},
			direction = defines.direction.south
		},{
			position = {x = 1.1, y = 1.1},
			direction = defines.direction.east
		},{
			position = {x = 1.1, y = -1.1},
			direction = defines.direction.north
		},{
			position = {x = 1.1, y = -1.1},
			direction = defines.direction.east
		},{
			position = {x = -1.1, y = 1.1},
			direction = defines.direction.south
		},{
			position = {x = -1.1, y = 1.1},
			direction = defines.direction.west
		},{
			position = {x = 0, y = 0},
			direction = defines.direction.south
		}},

		pipe_covers = util.pipe_covers,
		heat_pipe_covers = util.heat_pipe_covers,
		heat_picture = util.heat_picture,
	},
	energy_usage = "500MW",
	fluid_boxes = {{
		volume = 100,
		pipe_connections = {{
			connection_type = "linked",
			linked_connection_id = 1
		}},
		production_type = "output",
		filter = "halo-heat-energy"
	}},
	show_recipe_icon = false,
	show_recipe_icon_on_map = false,
	flags = {"not-on-map", "not-deconstructable", "not-blueprintable", "hide-alt-info", "not-flammable", "not-selectable-in-game"},
	selectable_in_game = false,
	name = "halo-heatsinklowreceiver",
	hidden = true,
	collision_box = {{-1.45,-1.45}, {1.45,1.45}},
	selection_box = {{-1.5,-1.5}, {1.5,1.5}},
	selection_priority = 1,
	tile_width = 3,
	tile_height = 3
},{
	type = "assembling-machine",
	fixed_recipe = "halo-heatsinkreceiverhigh",
	crafting_speed = 1,
	crafting_categories = {"halo-heatpump"},
	energy_source = {
		type = "heat",
		max_temperature = 999,
		specific_heat = "3MJ",
		max_transfer = "500MW",
		min_working_temperature = 800,
		-- No external corners of its own -- see halo-heatsinklowreceiver above.
		-- Co-located with the low receiver, but its one port sits on the tile
		-- south of the low receiver's, facing north, so the two ports are an
		-- ordinary adjacent pair on different tiles (like two heat pipes
		-- touching) rather than two ports on the same tile.
		connections = {{
			position = {x = 0, y = 1},
			direction = defines.direction.north
		}},
	},
	energy_usage = "500MW",
	fluid_boxes = {{
		volume = 100,
		pipe_connections = {{
			connection_type = "linked",
			linked_connection_id = 1
		}},
		production_type = "output",
		filter = "halo-heat-energy"
	}},
	show_recipe_icon = false,
	show_recipe_icon_on_map = false,
	flags = {"not-on-map", "not-deconstructable", "not-blueprintable", "hide-alt-info", "not-flammable", "not-selectable-in-game"},
	selectable_in_game = false,
	name = "halo-heatsinkhighreceiver",
	hidden = true,
	collision_box = {{-1.45,-1.45}, {1.45,1.45}},
	selection_box = {{-1.5,-1.5}, {1.5,1.5}},
	selection_priority = 1,
	tile_width = 3,
	tile_height = 3
},{
	type = "item",
	name = "halo-heatsink",
	icon = "__Solar-Halo__/heatsink/icon.png",
	subgroup = "environmental-protection",
	stack_size = 10,
	place_result = "halo-heatsink"
},{
	type = "recipe",
	name = "halo-heatsink",
	category = "crafting",
	enabled = false,
	ingredients = {
		{type = "item", name = "copper-plate", amount = 100},
		{type = "item", name = "pipe", amount = 10},
		{type = "item", name = "steel-plate", amount = 10}
	},
	results = {{type = "item", name = "halo-heatsink", amount = 1}},
	energy_required = 3
},{
	type = "recipe",
	name = "halo-heatsinkreceiverlow",
	category = "halo-heatpump",
	enabled = true,
	energy_required = 0.01,
	ingredients = {},
	results = {{
		type = "fluid", 
		name = "halo-heat-energy", 
		amount = 10,
		temperature = 160
	}},
	hidden = true,
	hidden_in_factoriopedia = true,
},{
	type = "recipe",
	name = "halo-heatsinkreceiverhigh",
	category = "halo-heatpump",
	enabled = true,
	energy_required = 0.01,
	ingredients = {},
	results = {{
		type = "fluid", 
		name = "halo-heat-energy", 
		amount = 10,
		temperature = 800
	}},
	hidden = true,
	hidden_in_factoriopedia = true,
},{
	type = "recipe-category",
	name = "halo-heatsink"
},{
	type = "recipe",
	name = "halo-heatsink-low",
	category = "halo-heatsink",
	icon = "__base__/graphics/icons/signal/signal-thermometer-blue.png",
	enabled = false,
	energy_required = 0.1,
	ingredients = {{
		type = "fluid", 
		name = "halo-heat-energy", 
		amount = 1,
		fluidbox_index = 1
	}},
	results = {},
	hide_from_player_crafting = true,
	subgroup = "fluid-recipes",
	order = "zzza",
},{
	type = "recipe",
	name = "halo-heatsink-high",
	category = "halo-heatsink",
	icon = "__base__/graphics/icons/signal/signal-thermometer-red.png",
	enabled = false,
	energy_required = 0.01,
	ingredients = {{
		type = "fluid", 
		name = "halo-heat-energy", 
		amount = 1,
		fluidbox_index = 2
	}},
	results = {},
	hide_from_player_crafting = true,
	subgroup = "fluid-recipes",
	order = "zzzb",
},{
	type = "recipe",
	name = "halo-heatsink-steam",
	category = "halo-heatsink",
	icon = "__base__/graphics/icons/fluid/steam.png",
	enabled = false,
	energy_required = 0.05,
	ingredients = {
		{
			type = "fluid", 
			name = "halo-heat-energy", 
			amount = 1,
			fluidbox_index = 1
		},{
			type = "fluid",
			name = "water",
			amount = 3,
			fluidbox_index = 3
		}
	},
	results = {{
		type = "fluid",
		name = "steam",
		amount = 30,
		temperature = 165
	}},
	hide_from_player_crafting = true,
	subgroup = "fluid-recipes",
	order = "zzzc",
},{
	type = "recipe",
	name = "halo-heatsink-coolant",
	category = "halo-heatsink",
	icon = "__space-age__/graphics/icons/fluid/fluoroketone-cold.png",
	enabled = false,
	energy_required = 0.01,
	ingredients = {
		{
			type = "fluid", 
			name = "halo-heat-energy", 
			amount = 1,
			fluidbox_index = 1
		},{
			type = "fluid",
			name = "fluoroketone-cold",
			amount = 10,
			fluidbox_index = 3
		}
	},
	results = {{
		type = "fluid",
		name = "fluoroketone-hot",
		amount = 10
	}},
	hide_from_player_crafting = true,
	subgroup = "fluid-recipes",
	order = "zzzd",
},{
	type = "recipe",
	name = "halo-heatsink-pipe",
	category = "halo-heatsink",
	enabled = false,
	energy_required = 100,
	ingredients = {
		{
			type = "fluid", 
			name = "halo-heat-energy", 
			amount = 1000,
			fluidbox_index = 2
		},{
			type = "item",
			name = "heat-pipe",
			amount = 1
		}
	},
	results = {{
		type = "item",
		name = "halo-superheated-pipe",
		amount = 1
	}},
	hide_from_player_crafting = true,
	subgroup = "fluid-recipes",
	order = "zzze",
}}
