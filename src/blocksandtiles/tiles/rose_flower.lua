local ROSE_FLOWER_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("ROSE_FLOWER_Block", ROSE_FLOWER_Block)
	end)
	addFunctionToTag("addTransparencyLookup", function()
		addTransparencyLookup(Tiles.ROSE_FLOWER_Block, TilesTransparency.FULL)
	end)
	addFunctionToTag("addLightSourceLookup", function()
		addLightSourceLookup(Tiles.ROSE_FLOWER_Block, LightSources[0])
	end)
	addFunctionToTag("madeThisTileNonCollidable", function()
		addTileNonCollidable(Tiles.ROSE_FLOWER_Block)
	end)
	addFunctionToTag("madeTile2DRenderedOnHUD", function()
		madeTile2DRenderedOnHUD(Tiles.ROSE_FLOWER_Block)
	end)
	addFunctionToTag("transform3DBlockToA2DTile", function()
		transform3DBlockToA2DTile(Tiles.ROSE_FLOWER_Block)
	end)
end

return stone_block
