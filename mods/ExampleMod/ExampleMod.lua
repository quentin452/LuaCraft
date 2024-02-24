--dependencies (if you had error caused by something like attempt to index global nil then try to add deps)
require("src/modloader/functiontags")
--mod dependencies (here you should add all lua of your mod here to don't had problems during initialize)
require("mods/ExampleMod/structures/generatepillar")

local ExampleMod = {}

function ExampleMod.initialize()
	--addTagToFunction are used here to unsure that structure will be generated
	--addTagToFunction(ExampleMod_generatePillarAtRandomLocation, "generateStructuresatRandomLocation") --this is disabled for now because see the line 5 in structureinit.lua
	addTagToFunctionWithXYZ(ExampleMod_generatePillarAtFixedPosition, "generateStructuresInPlayerRange", 0, 30, 22)
	addTagToFunctionWithXYZ(ExampleMod_generatePillarAtFixedPosition, "generateStructuresatFixedPositions", 0, 15, 20)
end

return ExampleMod
