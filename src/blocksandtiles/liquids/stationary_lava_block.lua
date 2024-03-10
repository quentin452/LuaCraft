local lavastationaryTexture = texturepathLuaCraft .. liquidtexturepathLuaCraft .. "lava_stationary.png"
local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"STATIONARY_LAVA_Block",
			TileMode.LiquidMode,
			CollideMode.NoCannotCollide,
			TilesTransparency.OPAQUE,
			LightSources[0],
			lavastationaryTexture,
			nil,
			nil
		)
	end)
end

return stone_block
