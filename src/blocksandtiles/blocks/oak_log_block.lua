local OAK_LOG_Block = nil

local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock("OAK_LOG_Block", OAK_LOG_Block)
	end)
	addFunctionToTag("addTransparencyLookup", function()
		addTransparencyLookup(Tiles.OAK_LOG_Block, TilesTransparency.OPAQUE)
	end)
	addFunctionToTag("addLightSourceLookup", function()
		addLightSourceLookup(Tiles.OAK_LOG_Block, LightSources[0])
	end)
	addFunctionToTag("useCustomTextureFORHUDTile", function()
		useCustomTextureFORHUDTile(Tiles.OAK_LOG_Block, HUDTilesTextureListPersonalized.oak_logsTopTexture, HUDTilesTextureListPersonalized.oak_logsSideTexture)
	end)
end

return stone_block
