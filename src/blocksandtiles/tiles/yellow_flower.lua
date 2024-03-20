local yellowflowerTexture = TexturepathLuaCraft .. TilesTexturepathLuaCraft .. "yellow_flower.png"
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
			Lovegraphics.newImage(yellowflowerTexture),
			nil,
			nil,
			nil,
			nil
		)
	end, GetSourcePath())
end

return stone_block
