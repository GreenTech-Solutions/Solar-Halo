-- heatsink/control.lua

local M = {}

-- Shared by on_built and migrations/1.2.0.lua: builds the low/high receiver
-- pair for a heatsink at `position`. Both receivers sit exactly on the
-- heatsink (so they stay inside its hitbox); their one internal heat
-- connection pairs up because the two ports are on adjacent tiles, not
-- because the entities are offset (see heatsink/data.lua).
function M.create_receivers(surface, position, force, direction)
	local receiverlow = surface.create_entity {
		name = "halo-heatsinklowreceiver",
		position = position,
		force = force,
		direction = direction,
	}
	receiverlow.destructible = false
	receiverlow.minable_flag = false

	local receiverhigh = surface.create_entity {
		name = "halo-heatsinkhighreceiver",
		position = position,
		force = force,
		direction = direction,
	}
	receiverhigh.destructible = false
	receiverhigh.minable_flag = false

	return receiverlow, receiverhigh
end

function M.on_built(entity)
	local receiverlow, receiverhigh = M.create_receivers(
		entity.surface, entity.position, entity.force_index, entity.direction)

	entity.fluidbox.add_linked_connection(1, receiverlow, 1)
	entity.fluidbox.add_linked_connection(2, receiverhigh, 1)
end

function M.on_removed(entity)
	local receiver, _ = entity.fluidbox.get_linked_connection(1)
	if receiver ~= nil then
		receiver.destroy()
	end

	receiver, _ = entity.fluidbox.get_linked_connection(2)
	if receiver ~= nil then
		receiver.destroy()
	end
end

-- The superheated pipe is a distinct entity from the plain heat pipe
-- specifically so it can't be confused with it during ghost/robot item
-- resolution (see heatsink/data.lua); it starts at ambient temperature like
-- any other entity, so it's set hot here on build instead.
function M.on_superheated_pipe_built(entity)
	entity.temperature = 800
end

return M
