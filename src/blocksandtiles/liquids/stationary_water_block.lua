local STATIONARY_WATER_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("STATIONARY_WATER_Block", STATIONARY_WATER_Block)
	end)
	addFunctionToTag("addTransparencyLookup", function()
		addTransparencyLookup(Tiles.STATIONARY_WATER_Block, TilesTransparency.OPAQUE)
	end)
	addFunctionToTag("addLightSourceLookup", function()
		addLightSourceLookup(Tiles.STATIONARY_WATER_Block, LightSources[0])
	end)
	addFunctionToTag("madeThisTileNonCollidable", function()
		addTileNonCollidable(Tiles.STATIONARY_WATER_Block)
	end)
end

return stone_block
