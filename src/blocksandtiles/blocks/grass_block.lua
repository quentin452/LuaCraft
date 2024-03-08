local GRASS_Block = nil

local grass_block = {}

function grass_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("GRASS_Block", GRASS_Block)
	end)
	addFunctionToTag("addTransparencyLookup", function()
		addTransparencyLookup(Tiles.GRASS_Block, TilesTransparency.OPAQUE)
	end)
	addFunctionToTag("addLightSourceLookup", function()
		addLightSourceLookup(Tiles.GRASS_Block, LightSources[0])
	end)
end

return grass_block
