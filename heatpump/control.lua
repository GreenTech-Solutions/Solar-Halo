-- heatpump/control.lua

local halo_events = require("halo-events")

local M = {}

local function create_reactor(entity)
	local x, y = halo_events.getOffset(entity.direction)
	local pos = {x = entity.position.x + x, y = entity.position.y + y}
	local reactor = entity.surface.create_entity {
		name = "halo-heatpump-reactor",
		position = pos,
		force = entity.force_index,
		direction = entity.direction,
	}
	reactor.destructible = false
	reactor.minable_flag = false
	return reactor
end

function M.on_built(entity)
	local receiver = entity.surface.create_entity {
		name = "halo-heatpump-receiver",
		position = entity.position,
		force = entity.force_index,
		direction = entity.direction,
	}
	receiver.destructible = false
	receiver.minable_flag = false

	local reactor = create_reactor(entity)

	entity.fluidbox.add_linked_connection(1, receiver, 1)
	entity.fluidbox.add_linked_connection(2, reactor, 1)
end

function M.on_removed(entity)
	local receiver, _ = entity.fluidbox.get_linked_connection(1)
	if receiver ~= nil then
		receiver.destroy()
	end

	local reactor, _ = entity.fluidbox.get_linked_connection(2)
	if reactor ~= nil then
		reactor.destroy()
	end
end

function M.on_rotated(entity)
	local receiver, _ = entity.fluidbox.get_linked_connection(1)
	if receiver ~= nil then
		receiver.direction = entity.direction
	end

	local reactor, _ = entity.fluidbox.get_linked_connection(2)
	if reactor ~= nil then
		reactor.destroy()
	end
	local new_reactor = create_reactor(entity)
	entity.fluidbox.add_linked_connection(2, new_reactor, 1)
end

return M
