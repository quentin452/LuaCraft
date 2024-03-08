local STONE_BRICK_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("STONE_BRICK_Block", STONE_BRICK_Block)
	end)
	addFunctionToTag("addTransparencyLookup", function()
		addTransparencyLookup(Tiles.STONE_BRICK_Block, TilesTransparency.OPAQUE)
	end)
	addFunctionToTag("addLightSourceLookup", function()
		addLightSourceLookup(Tiles.STONE_BRICK_Block, LightSources[0])
	end)
end

return stone_block
