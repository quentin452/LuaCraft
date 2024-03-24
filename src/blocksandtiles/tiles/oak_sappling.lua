local oak_sapplingsTexture = TexturepathLuaCraft .. TilesTexturepathLuaCraft .. "oak_sapplings.png"
local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"OAK_SAPPLING_Block",
			TileMode.TileMode,
			CollideMode.NoCannotCollide,
			TilesTransparency.FULL,
			LightSources[0],
			oak_sapplingsTexture,
			nil,
			nil
		)
	end, GetSourcePath())
end

return stone_block
