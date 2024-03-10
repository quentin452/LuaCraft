local roseflowerTexture = texturepathLuaCraft .. tilestexturepathLuaCraft .. "rose_flower.png"
local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"ROSE_FLOWER_Block",
			TileMode.TileMode,
			CollideMode.NoCannotCollide,
			TilesTransparency.FULL,
			LightSources[0],
			roseflowerTexture,
			nil,
			nil
		)
	end)
end

return stone_block
