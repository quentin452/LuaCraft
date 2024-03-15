local lavaTexture = TexturepathLuaCraft .. LiquidTexturepathLuaCraft .. "lava.png"
local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"LAVA_Block",
			TileMode.LiquidMode,
			CollideMode.NoCannotCollide,
			TilesTransparency.OPAQUE,
			LightSources[0],
			lavaTexture,
			nil,
			nil
		)
	end)
end

return stone_block
