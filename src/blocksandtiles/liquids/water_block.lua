local WATER_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("WATER_Block", WATER_Block)
	end)
	addFunctionToTag("addTransparencyLookup", function()
		addTransparencyLookup(Tiles.WATER_Block, TilesTransparency.OPAQUE)
	end)
	addFunctionToTag("addLightSourceLookup", function()
		addLightSourceLookup(Tiles.WATER_Block, LightSources[0])
	end)
	addFunctionToTag("madeThisTileNonCollidable", function()
		addTileNonCollidable(Tiles.WATER_Block)
	end)
end

return stone_block
