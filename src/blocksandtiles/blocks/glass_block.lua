local glassTexture = TexturepathLuaCraft .. BlockTexturepathLuaCraft .. "glass.png"
local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"GLASS_Block",
			TileMode.BlockMode,
			CollideMode.YesCanCollide,
			TilesTransparency.NONE,
			LightSources[0],
			glassTexture,
			nil,
			nil
		)
	end)
end

return stone_block
