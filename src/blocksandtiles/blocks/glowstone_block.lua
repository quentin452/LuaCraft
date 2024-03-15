local glowstoneTexture = TexturepathLuaCraft .. BlockTexturepathLuaCraft .. "glowstone.png"
local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"GLOWSTONE_Block",
			TileMode.BlockMode,
			CollideMode.YesCanCollide,
			TilesTransparency.NONE,
			LightSources[15],
			glowstoneTexture,
			nil,
			nil
		)
	end)
end

return stone_block
