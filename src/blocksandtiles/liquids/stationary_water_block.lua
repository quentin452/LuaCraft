local waterstationaryTexture = TexturepathLuaCraft .. LiquidTexturepathLuaCraft .. "water_stationary.png"
local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"STATIONARY_WATER_Block",
			TileMode.LiquidMode,
			CollideMode.NoCannotCollide,
			TilesTransparency.OPAQUE,
			LightSources[0],
			waterstationaryTexture,
			Lovegraphics.newImage(waterstationaryTexture),
			nil,
			nil,
			nil,
			nil
		)
	end, GetSourcePath())
end

return stone_block
