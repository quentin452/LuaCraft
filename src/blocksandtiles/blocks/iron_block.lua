local IRON_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("IRON_Block", IRON_Block)
	end)
	addFunctionToTag("addTransparencyLookup", function()
		addTransparencyLookup(Tiles.IRON_Block, TilesTransparency.OPAQUE)
	end)
	addFunctionToTag("addLightSourceLookup", function()
		addLightSourceLookup(Tiles.IRON_Block, LightSources[0])
	end)
end

return stone_block
