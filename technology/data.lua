local science = table.deepcopy(data.raw["tool"]["electromagnetic-science-pack"])
science.name = "halo-science-pack"
science.icon = "__Solar-Halo__/science.png"
science.icon_size = 64
data:extend{science}

data:extend{{
	type = "recipe",
	name = "halo-science-pack",
	category = "crafting-with-fluid",
	enabled = false,
	energy_required = 1,
	ingredients = {
	{type = "fluid", name = "halo-compute", amount = 4000},
	{type = "item", name = "battery", amount = 1},
	{type = "item", name = "advanced-circuit", amount = 1},
	},
	results = {{type = "item", name = "halo-science-pack", amount = 1}}
}}

data:extend{{
	type = "technology",
	name = "halo-discovery-solar",
	icon = "__Solar-Halo__/space/solarorbit.png",
	icon_size = 128,
	essential = true,
	unit = {count = 1000, time = 60, ingredients =
		{
			{"automation-science-pack", 1},
			{"logistic-science-pack", 1},
			{"chemical-science-pack", 1},
			{"space-science-pack", 1}
		}
	},
	prerequisites = {"planet-discovery-vulcanus"},
	effects = {{
			type = "unlock-space-location",
			space_location = "halo-solar-orbit"
	}}
},{
	type = "technology",
	name = "halo-compute",
	icon = "__Solar-Halo__/science.png",
	icon_size = 64,
	essential = true,
	unit = {count = 300, time = 30, ingredients =
		{
			{"automation-science-pack", 1},
			{"logistic-science-pack", 1},
			{"chemical-science-pack", 1},
			{"space-science-pack", 1}
		}
	},
	prerequisites = {"halo-discovery-solar"},
	effects = {{
			type = "unlock-recipe",
			recipe = "halo-computer"
		},{
			type = "unlock-recipe",
			recipe = "halo-compute"
		},{
			type = "unlock-recipe",
			recipe = "halo-science-pack"
		},{
			type = "unlock-recipe",
			recipe = "halo-heatsink"
		},{
			type = "unlock-recipe",
			recipe = "halo-heatsink-low"
		},{
			type = "unlock-recipe",
			recipe = "halo-heatsink-steam"
		},{
			type = "unlock-recipe",
			recipe = "halo-thermostat"
	}}
},{
	type = "technology",
	name = "halo-terminal",
	icon = "__Solar-Halo__/terminal/charged.png",
	essential = false,
	unit = {count = 2000, time = 30, ingredients =
		{
			{"automation-science-pack", 1},
			{"logistic-science-pack", 1},
			{"chemical-science-pack", 1},
			{"space-science-pack", 1},
			{"electromagnetic-science-pack", 1},
			{"halo-science-pack", 1}
		}
	},
	prerequisites = {"halo-compute", "electromagnetic-plant"},
	effects = {{
			type = "unlock-recipe",
			recipe = "halo-terminal"
		},{
			type = "unlock-recipe",
			recipe = "halo-charge"
		},{
			type = "unlock-recipe",
			recipe = "halo-discharge"
	}}
},{
	type = "technology",
	name = "halo-nav-computer",
	icon = "__Solar-Halo__/nav-computer/nav-pack.png",
	essential = false,
	unit = {count = 1500, time = 30, ingredients =
		{
			{"automation-science-pack", 1},
			{"logistic-science-pack", 1},
			{"chemical-science-pack", 1},
			{"space-science-pack", 1},
			{"halo-science-pack", 1},
		}
	},
	prerequisites = {"halo-compute"},
	effects = {{
			type = "unlock-recipe",
			recipe = "halo-nav-computer"
		},{
			type = "unlock-recipe",
			recipe = "halo-nav-pack"
	}}
},{
	type = "technology",
	name = "halo-rocket",
	icon = "__base__/graphics/icons/rocket-part.png",
	essential = false,
	unit = {count = 1500, time = 60, ingredients =
		{
			{"automation-science-pack", 1},
			{"logistic-science-pack", 1},
			{"chemical-science-pack", 1},
			{"production-science-pack", 1},
			{"space-science-pack", 1},
			{"halo-science-pack", 1},
			{"electromagnetic-science-pack", 1},
			{"cryogenic-science-pack", 1},
		}
	},
	prerequisites = {"halo-terminal", "railgun"},
	effects = {{
			type = "unlock-recipe",
			recipe = "halo-rocket-silo"
		},{
			type = "unlock-recipe",
			recipe = "halo-rocket-part"
	}}
},{
	type = "technology",
	name = "halo-module",
	icon = "__Solar-Halo__/modules/module-tech.png",
	essential = false,
	unit = {count = 3000, time = 30, ingredients =
		{
			{"automation-science-pack", 1},
			{"logistic-science-pack", 1},
			{"chemical-science-pack", 1},
			{"utility-science-pack", 1},
			{"space-science-pack", 1},
			{"halo-science-pack", 1}
		}
	},
	prerequisites = {"halo-compute"},
	effects = {} --data-updates.lua
},{
	type = "technology",
	name = "halo-speed",
	icon = "__Solar-Halo__/computer/compute.png",
	essential = false,
	upgrade = true,
	max_level = "infinite",
	unit = {count_formula = "1000 * 1.5^l", time = 30, ingredients =
		{
			{"automation-science-pack", 1},
			{"logistic-science-pack", 1},
			{"chemical-science-pack", 1},
			{"production-science-pack", 1},
			{"space-science-pack", 1},
			{"halo-science-pack", 1}
		}
	},
	prerequisites = {"halo-compute"},
	effects = {{
		type = "change-recipe-productivity",
		recipe = "halo-compute",
		change = .1,
	}}
},{
	type = "technology",
	name = "halo-heatsink-high",
	icon = "__base__/graphics/icons/signal/signal-thermometer-red.png",
	essential = false,
	unit = {count = 1000, time = 30, ingredients =
		{
			{"automation-science-pack", 1},
			{"logistic-science-pack", 1},
			{"chemical-science-pack", 1},
			{"space-science-pack", 1},
			{"halo-science-pack", 1}
		}
	},
	prerequisites = {"halo-compute", "metallurgic-science-pack"},
	effects = {{
			type = "unlock-recipe",
			recipe = "halo-heatpump"
		},{
			type = "unlock-recipe",
			recipe = "halo-heatsink-high"
		},{
			type = "unlock-recipe",
			recipe = "halo-heatsink-pipe"
		},{
			type = "unlock-recipe",
			recipe = "halo-heatsink-coolant"
	}}
},{
	type = "technology",
	name = "halo-solar",
	icon = "__base__/graphics/icons/solar-panel.png",
	essential = false,
	upgrade = true,
	max_level = "infinite",
	unit = {count_formula = "3000 * 1.5^l", time = 30, ingredients =
		{
			{"automation-science-pack", 1},
			{"logistic-science-pack", 1},
			{"chemical-science-pack", 1},
			{"production-science-pack", 1},
			{"space-science-pack", 1},
			{"halo-science-pack", 1}
		}
	},
	prerequisites = {"halo-compute"},
	effects = {{
		type = "nothing",
		effect_description = "+10% solar panel energy production",
		icon = "__base__/graphics/icons/solar-panel.png",
	}},
},{
	type = "technology",
	name = "halo-gmo",
	icon = "__Solar-Halo__/gmo/icon.png",
	essential = false,
	unit = {count = 2000, time = 30, ingredients =
		{
			{"automation-science-pack", 1},
			{"logistic-science-pack", 1},
			{"chemical-science-pack", 1},
			{"space-science-pack", 1},
			{"halo-science-pack", 1},
			{"agricultural-science-pack", 1}
		}
	},
	prerequisites = {"halo-compute", "agricultural-science-pack"},
	effects = {{
		type = "unlock-recipe",
		recipe = "halo-gmo"
	}}
},{
	type = "technology",
	name = "halo-sim",
	icon = "__base__/graphics/icons/automation-science-pack.png",
	essential = false,
	unit = {count = 1000, time = 30, ingredients =
		{
			{"automation-science-pack", 1},
			{"logistic-science-pack", 1},
			{"chemical-science-pack", 1},
			{"space-science-pack", 1},
			{"halo-science-pack", 1}
		}
	},
	prerequisites = {"halo-compute"},
	effects = {{
			type = "unlock-recipe",
			recipe = "halo-automation-science-pack"
		},{
			type = "unlock-recipe",
			recipe = "halo-logistic-science-pack"
		},{
			type = "unlock-recipe",
			recipe = "halo-chemical-science-pack"
		},{
			type = "unlock-recipe",
			recipe = "halo-space-science-pack"
		},{
			type = "unlock-recipe",
			recipe = "halo-halo-science-pack"
	}}
},{
	type = "technology",
	name = "halo-discovery-station",
	icons = {{
		icon = "__Solar-Halo__/space/solarorbit.png",
		icon_size = 128,
	},{
		icon = "__Solar-Halo__/space/station-foundation.png",
		scale = 0.36
	}},
	essential = true,
	unit = {count = 5000, time = 60, ingredients =
		{
			{"automation-science-pack", 1},
			{"logistic-science-pack", 1},
			{"chemical-science-pack", 1},
			{"production-science-pack", 1},
			{"space-science-pack", 1},
			{"halo-science-pack", 1},
			{"metallurgic-science-pack", 1},
			{"cryogenic-science-pack", 1},
		}
	},
	prerequisites = {"halo-heatsink-high", "foundation"},
	effects = {{
			type = "unlock-space-location",
			space_location = "halo-solar-station"
		},{
			type = "unlock-recipe",
			recipe = "halo-foundation"
	}}
}}

-- Other mods can switch these features off with the startup settings.
if not settings.startup["halo-science-simulation"].value then
	data.raw["technology"]["halo-sim"] = nil
end
if not settings.startup["halo-module-specialization"].value then
	data.raw["technology"]["halo-module"] = nil
end
