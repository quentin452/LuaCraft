local COAL_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("COAL_Block", COAL_Block)
	end)
	addFunctionToTag("addTransparencyLookup", function()
		addTransparencyLookup(Tiles.COAL_Block, TilesTransparency.OPAQUE)
	end)
	addFunctionToTag("addLightSourceLookup", function()
		addLightSourceLookup(Tiles.COAL_Block, LightSources[0])
	end)
end

return stone_block
