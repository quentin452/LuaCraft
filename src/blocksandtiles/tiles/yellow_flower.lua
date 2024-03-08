local YELLO_FLOWER_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("YELLO_FLOWER_Block", YELLO_FLOWER_Block)
	end)

	addFunctionToTag("addTransparencyLookup", function()
		addTransparencyLookup(Tiles.YELLO_FLOWER_Block, TilesTransparency.FULL)
	end)
	addFunctionToTag("addLightSourceLookup", function()
		addLightSourceLookup(Tiles.YELLO_FLOWER_Block, LightSources[0])
	end)
	addFunctionToTag("madeThisTileNonCollidable", function()
		addTileNonCollidable(Tiles.YELLO_FLOWER_Block)
	end)
	addFunctionToTag("madeTile2DRenderedOnHUD", function()
		madeTile2DRenderedOnHUD(Tiles.YELLO_FLOWER_Block)
	end)
	addFunctionToTag("transform3DBlockToA2DTile", function()
		transform3DBlockToA2DTile(Tiles.YELLO_FLOWER_Block)
	end)
end

return stone_block
