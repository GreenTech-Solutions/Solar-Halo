--control.lua
--
-- This file only wires together the per-feature control scripts below; the
-- actual entity logic lives next to each feature's data.lua, mirroring how
-- data.lua itself is split (see there for the require list).
--
-- The entity built/removed/rotated events are shared by several features at
-- once, and Factorio only allows a single handler per event id (a later
-- script.on_event call for the same event replaces an earlier one, it does
-- not add a second listener) -- so those three events are dispatched here,
-- from a small per-entity-name lookup table, instead of each feature
-- registering its own handler for them.

local halo_events = require("halo-events")
local computer = require("computer.control")
local terminal = require("terminal.control")
local heatpump = require("heatpump.control")
local heatsink = require("heatsink.control")
local space = require("space.control")
require("nav-computer.control")

local on_built_by_name = {
	["halo-computer"] = computer.on_built,
	["halo-terminal"] = terminal.on_built,
	["halo-heatpump"] = heatpump.on_built,
	["halo-heatsink"] = heatsink.on_built,
	["halo-superheated-pipe"] = heatsink.on_superheated_pipe_built,
}

local on_removed_by_name = {
	["halo-computer"] = computer.on_removed,
	["halo-terminal"] = terminal.on_removed,
	["halo-heatpump"] = heatpump.on_removed,
	["halo-heatsink"] = heatsink.on_removed,
}

local on_rotated_by_name = {
	["halo-computer"] = computer.on_rotated,
	["halo-terminal"] = terminal.on_rotated,
	["halo-heatpump"] = heatpump.on_rotated,
}

script.on_init(function()
	computer.ensure_storage()
	space.ensure_storage()
	space.ensure_solar_station_power()
end)

script.on_configuration_changed(function()
	terminal.ensure_all_helpers()
	computer.ensure_storage()
	space.ensure_storage()
	space.ensure_solar_station_power()
end)

----------building created---------
script.on_event(halo_events.entity_built, function(event)
	local entity = halo_events.get_built_entity(event)
	if not entity.valid then return end

	local handler = on_built_by_name[entity.name]
	if handler then
		handler(entity)
	end
end)

---------building removed---------
script.on_event(halo_events.entity_removed, function(event)
	local entity = event.entity
	if not entity.valid then return end

	local handler = on_removed_by_name[entity.name]
	if handler then
		handler(entity)
	end
end)

---------building rotated---------
script.on_event(defines.events.on_player_rotated_entity, function(event)
	local entity = event.entity
	if not entity.valid then return end

	local handler = on_rotated_by_name[entity.name]
	if handler then
		handler(entity)
	end
end)
