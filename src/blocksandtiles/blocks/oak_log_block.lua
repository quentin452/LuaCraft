local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("OAK_LOG_Block", 	 TileMode.BlockMode,
	CollideMode.YesCanCollide,
		TilesTransparency.OPAQUE,
		LightSources[0])
	end)
	addFunctionToTag("useCustomTextureFORHUDTile", function()
		useCustomTextureFORHUDTile(
			Tiles.OAK_LOG_Block.id,
			HUDTilesTextureListPersonalized.oak_logsTopTexture,
			HUDTilesTextureListPersonalized.oak_logsSideTexture
		)
	end)
end

return stone_block
