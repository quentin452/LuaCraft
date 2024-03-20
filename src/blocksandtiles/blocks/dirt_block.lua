local dirtTexture = TexturepathLuaCraft .. BlockTexturepathLuaCraft .. "dirt.png"
local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"DIRT_Block",
			TileMode.BlockMode,
			CollideMode.YesCanCollide,
			TilesTransparency.OPAQUE,
			LightSources[0],
			dirtTexture,
			Lovegraphics.newImage(dirtTexture),
			nil,
			nil,
			nil,
			nil
		)
	end, GetSourcePath())
end

return stone_block
