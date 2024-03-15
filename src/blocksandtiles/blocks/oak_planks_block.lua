local oak_planksTexture = TexturepathLuaCraft .. BlockTexturepathLuaCraft .. "oak_planks.png"
local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"OAK_PLANK_Block",
			TileMode.BlockMode,
			CollideMode.YesCanCollide,
			TilesTransparency.OPAQUE,
			LightSources[0],
			oak_planksTexture,
			nil,
			nil
		)
	end)
end

return stone_block
