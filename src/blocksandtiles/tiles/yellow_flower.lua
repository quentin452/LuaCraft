local yellowflowerTexture = texturepathLuaCraft .. tilestexturepathLuaCraft .. "yellow_flower.png"
local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"YELLO_FLOWER_Block",
			TileMode.TileMode,
			CollideMode.NoCannotCollide,
			TilesTransparency.FULL,
			LightSources[0],
			yellowflowerTexture,
			nil,
			nil
		)
	end)
end

return stone_block
