local waterstationaryTexture = texturepathLuaCraft .. liquidtexturepathLuaCraft .. "water_stationary.png"
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
			nil,
			nil
		)
	end)
end

return stone_block
