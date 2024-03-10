local oak_sapplingsTexture = texturepathLuaCraft .. tilestexturepathLuaCraft .. "oak_sapplings.png"
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
	end)
end

return stone_block
