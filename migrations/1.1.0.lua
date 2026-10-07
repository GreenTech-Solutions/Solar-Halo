-- halo-heatsink used to split its 4 external heat-pipe corners into two
-- independently-heated networks (2 corners feeding halo-heatsinklowreceiver,
-- 2 feeding halo-heatsinkhighreceiver). That's now one real network: the low
-- receiver owns all 4 corners, and conducts to the high receiver through one
-- ordinary adjacent heat connection between them (see heatsink/data.lua and
-- heatsink/control.lua). This migration rebuilds the receiver pair on every
-- already-placed halo-heatsink with the new geometry.
--
-- The visible halo-heatsink entity itself is never touched, so its selected
-- recipe should survive on its own -- but the recipe is captured and
-- reapplied anyway, in case briefly clearing its fluidbox's linked
-- connections during the swap causes the game to unset it.

local heatsink_control = require("heatsink.control")

for _, surface in pairs(game.surfaces) do
	for _, entity in pairs(surface.find_entities_filtered{name = "halo-heatsink"}) do
		local recipe = entity.get_recipe()
		local recipe_name = recipe and recipe.name

		local old_low = entity.fluidbox.get_linked_connection(1)
		if old_low then old_low.destroy() end
		local old_high = entity.fluidbox.get_linked_connection(2)
		if old_high then old_high.destroy() end

		local receiverlow, receiverhigh = heatsink_control.create_receivers(
			entity.surface, entity.position, entity.force, entity.direction)

		entity.fluidbox.add_linked_connection(1, receiverlow, 1)
		entity.fluidbox.add_linked_connection(2, receiverhigh, 1)

		if recipe_name and not entity.get_recipe() then
			entity.set_recipe(recipe_name)
		end
	end
end
