-- halo-events.lua
--
-- Shared event-group constants used by the per-feature control scripts, so
-- each of them can subscribe to the same "entity built"/"entity removed"
-- groups without repeating the define lists (and without clobbering each
-- other's handlers -- see the note in control.lua about registering these
-- with script.on_event once per group, not once per feature).

local halo_events = {}

halo_events.entity_built = {
	defines.events.on_built_entity,
	defines.events.on_robot_built_entity,
	defines.events.script_raised_built,
	defines.events.script_raised_revive,
	defines.events.on_space_platform_built_entity,
	defines.events.on_biter_base_built,
}

halo_events.entity_removed = {
	defines.events.on_player_mined_entity,
	defines.events.on_robot_mined_entity,
	defines.events.on_entity_died,
	defines.events.script_raised_destroy,
	defines.events.on_space_platform_mined_entity,
}

function halo_events.get_built_entity(event)
	return event.created_entity or event.entity or event.destination
end

function halo_events.getOffset(direction)
	if direction == defines.direction.north then
		return 0, -0.5
	elseif direction == defines.direction.east then
		return 0.5, 0
	elseif direction == defines.direction.south then
		return 0, 0.5
	elseif direction == defines.direction.west then
		return -0.5, 0
	end
end

return halo_events
