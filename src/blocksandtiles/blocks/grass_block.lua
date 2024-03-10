local grass_block = {}

function grass_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"GRASS_Block",
			TileMode.BlockMode,
			CollideMode.YesCanCollide,
			TilesTransparency.OPAQUE,
			LightSources[0]
		)
	end)
	addFunctionToTag("useCustomTextureFORHUDTile", function()
		useCustomTextureFORHUDTile(
			Tiles.GRASS_Block.id,
			HUDTilesTextureListPersonalized.grassTopTexture,
			HUDTilesTextureListPersonalized.grassSideTexture
		)
	end)
end

return grass_block
