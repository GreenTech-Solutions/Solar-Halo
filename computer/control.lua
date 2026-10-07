-- computer/control.lua

local M = {}

function M.ensure_storage()
	storage["computer"] = storage["computer"] or {}
end

function M.on_built(entity)
	M.ensure_storage()
	local heat = entity.surface.create_entity {
		name = "halo-computer-heat",
		position = entity.position,
		force = entity.force_index,
		direction = entity.direction,
		create_build_effect_smoke = false,
	}
	heat.destructible = false
	heat.minable_flag = false
	storage["computer"][entity.unit_number] = {c = entity, h = heat, p = 0}
end

function M.on_removed(entity)
	local tuple = storage["computer"][entity.unit_number]
	storage["computer"][entity.unit_number] = nil
	if tuple ~= nil and tuple.h ~= nil and tuple.h.valid then
		tuple.h.destroy()
	end
end

function M.on_rotated(entity)
	local tuple = storage["computer"][entity.unit_number]
	if tuple ~= nil and tuple.h ~= nil and tuple.h.valid then
		tuple.h.direction = tuple.c.direction
	end
end

script.on_event(defines.events.on_tick, function(event)
	if event.tick % 67 ~= 0 then return end

	for i, t in pairs(storage["computer"]) do
		if t.c.valid and t.h.valid then
			local newp = t.c.products_finished
			local dur = (newp - t.p) / t.c.crafting_speed
			local mult = 1000 * 0.5 * (t.c.consumption_bonus + 1)
			t.h.temperature = t.h.temperature + dur * mult / 200
			t.p = newp

			t.c.disabled_by_script = (t.h.temperature >= 200)
		end
	end
end)

return M
