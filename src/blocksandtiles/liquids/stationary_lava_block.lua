local lavastationaryTexture = TexturepathLuaCraft .. LiquidTexturepathLuaCraft .. "lava_stationary.png"
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
			Lovegraphics.newImage(lavastationaryTexture),
			nil,
			nil,
			nil,
			nil
		)
	end, GetSourcePath())
end

return stone_block
