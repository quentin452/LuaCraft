local goldTexture = TexturepathLuaCraft .. BlockTexturepathLuaCraft .. "gold.png"
local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"GOLD_Block",
			TileMode.BlockMode,
			CollideMode.YesCanCollide,
			TilesTransparency.OPAQUE,
			LightSources[0],
			goldTexture,
			Lovegraphics.newImage(goldTexture),
			nil,
			nil,
			nil,
			nil
		)
	end, GetSourcePath())
end

return stone_block
