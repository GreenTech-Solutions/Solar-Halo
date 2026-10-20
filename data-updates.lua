if settings.startup["halo-module-specialization"].value then
	require("modules.data-updates")
end
require("nav-computer.data-updates")
if settings.startup["halo-science-simulation"].value then
	require("simulation.data-updates")
end

----------Lab Fix----------
for name, proto in pairs(data.raw["lab"]) do
	table.insert(proto.inputs, "halo-science-pack")
end
