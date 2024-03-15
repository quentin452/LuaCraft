local ironTexture = TexturepathLuaCraft .. BlockTexturepathLuaCraft .. "iron.png"
local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"IRON_Block",
			TileMode.BlockMode,
			CollideMode.YesCanCollide,
			TilesTransparency.OPAQUE,
			LightSources[0],
			ironTexture,
			nil,
			nil
		)
	end)
end

return stone_block
