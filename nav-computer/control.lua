-- nav-computer/control.lua

script.on_event(defines.events.on_script_trigger_effect, function(event)
	if event.effect_id ~= "navcomp" then
		return
	end

	local e = event.target_entity
	if e ~= nil and e.valid and e.type == "asteroid" then
		e.destroy()
	end
end)
