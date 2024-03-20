local cobbleTexture = TexturepathLuaCraft .. BlockTexturepathLuaCraft .. "cobble.png"
local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"COBBLE_Block",
			TileMode.BlockMode,
			CollideMode.YesCanCollide,
			TilesTransparency.OPAQUE,
			LightSources[0],
			cobbleTexture,
			Lovegraphics.newImage(cobbleTexture),
			nil,
			nil,
			nil,
			nil
		)
	end, GetSourcePath())
end

return stone_block
