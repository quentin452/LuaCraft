--dependencies (if you had error caused by something like attempt to index global nil then try to add deps)
require("src/modloader/functiontags")
--mod dependencies (here you should add all lua of your mod here to don't had problems during initialize)
require("mods/ExampleMod/structures/generatepillar")

local ExampleMod = {}

function ExampleMod.initialize()
	addTagToFunction(ExampleMod_generatePillarAtRandomLocation, "randomLocation")
	addTagToFunction(ExampleMod_generatePillarAtFixedPosition, "fixedPosition")
end

return ExampleMod
