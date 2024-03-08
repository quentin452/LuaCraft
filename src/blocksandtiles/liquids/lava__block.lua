local LAVA_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("LAVA_Block", LAVA_Block)
	end)
	addFunctionToTag("addTransparencyLookup", function()
		addTransparencyLookup(Tiles.LAVA_Block, TilesTransparency.OPAQUE)
	end)
	addFunctionToTag("addLightSourceLookup", function()
		addLightSourceLookup(Tiles.LAVA_Block, LightSources[0])
	end)
	addFunctionToTag("madeThisTileNonCollidable", function()
		addTileNonCollidable(Tiles.LAVA_Block)
	end)
end

return stone_block
