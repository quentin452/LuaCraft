local waterTexture = TexturepathLuaCraft .. LiquidTexturepathLuaCraft .. "water.png"
local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"WATER_Block",
			TileMode.LiquidMode,
			CollideMode.NoCannotCollide,
			TilesTransparency.OPAQUE,
			LightSources[0],
			waterTexture,
			nil,
			nil
		)
	end)
end

return stone_block
