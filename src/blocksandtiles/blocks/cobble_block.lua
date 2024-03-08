local COBBLE_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("COBBLE_Block", COBBLE_Block)
	end)
	addFunctionToTag("addTransparencyLookup", function()
		addTransparencyLookup(Tiles.COBBLE_Block, TilesTransparency.OPAQUE)
	end)
	addFunctionToTag("addLightSourceLookup", function()
		addLightSourceLookup(Tiles.COBBLE_Block, LightSources[0])
	end)
end

return stone_block
