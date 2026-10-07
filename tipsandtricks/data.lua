data:extend {{
    type = "tips-and-tricks-item",
    name = "halo-solar-halo-briefing",
	tag = "[entity=halo-flare]",
    category = "space-age",
	order = "halo1",
    indent = 0,
    trigger = {
        type = "research",
        technology = "halo-discovery-solar"
    },
},{
    type = "tips-and-tricks-item",
    name = "halo-compute",
	tag = "[entity=halo-computer]",
    category = "space-age",
	order = "halo2",
    indent = 1,
    trigger = {
        type = "build-entity",
        entity = "halo-computer",
    },
},{
    type = "tips-and-tricks-item",
    name = "halo-solar-station-briefing",
	tag = "[item=halo-foundation]",
    category = "space-age",
	order = "halo3",
    indent = 1,
    trigger = {
        type = "research",
        technology = "halo-discovery-station"
    },
}}