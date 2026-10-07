-- terminal/control.lua

local M = {}

local function create_hidden(entity, name)
	local helper = entity.surface.create_entity {
		name = name,
		position = entity.position,
		force = entity.force_index,
		direction = entity.direction,
	}
	helper.destructible = false
	helper.minable_flag = false
	return helper
end

-- Creates whichever hidden helpers this terminal is missing. The turbine turns
-- discharged electrolyte into electricity, the charger turns surplus
-- electricity into the "fluid" the charge recipe consumes. Safe to run on
-- terminals that already have them.
function M.ensure_helpers(entity)
	if not entity.fluidbox.get_linked_connection(1) then
		entity.fluidbox.add_linked_connection(1, create_hidden(entity, "halo-terminal-turbine"), 1)
	end
	if not entity.fluidbox.get_linked_connection(2) then
		entity.fluidbox.add_linked_connection(2, create_hidden(entity, "halo-terminal-charger"), 1)
	end
end

function M.ensure_all_helpers()
	for _, surface in pairs(game.surfaces) do
		for _, entity in pairs(surface.find_entities_filtered{name = "halo-terminal"}) do
			M.ensure_helpers(entity)
		end
	end
end

function M.on_built(entity)
	M.ensure_helpers(entity)
end

function M.on_removed(entity)
	for id = 1, 2 do
		local helper, _ = entity.fluidbox.get_linked_connection(id)
		if helper ~= nil then
			helper.destroy()
		end
	end
end

function M.on_rotated(entity)
	for id = 1, 2 do
		local helper, _ = entity.fluidbox.get_linked_connection(id)
		if helper ~= nil then
			helper.direction = entity.direction
		end
	end
end

return M
