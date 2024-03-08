local OAK_SAPPLING_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("OAK_SAPPLING_Block", OAK_SAPPLING_Block)
	end)
	addFunctionToTag("addTransparencyLookup", function()
		addTransparencyLookup(Tiles.OAK_SAPPLING_Block, TilesTransparency.FULL)
	end)
	addFunctionToTag("addLightSourceLookup", function()
		addLightSourceLookup(Tiles.OAK_SAPPLING_Block, LightSources[0])
	end)
	addFunctionToTag("madeThisTileNonCollidable", function()
		addTileNonCollidable(Tiles.OAK_SAPPLING_Block)
	end)
	addFunctionToTag("madeTile2DRenderedOnHUD", function()
		madeTile2DRenderedOnHUD(Tiles.OAK_SAPPLING_Block)
	end)
	addFunctionToTag("transform3DBlockToA2DTile", function()
		transform3DBlockToA2DTile(Tiles.OAK_SAPPLING_Block)
	end)
end

return stone_block
