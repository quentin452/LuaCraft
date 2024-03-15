local spongeTexture = TexturepathLuaCraft .. BlockTexturepathLuaCraft .. "sponge.png"
local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"SPONGE_Block",
			TileMode.BlockMode,
			CollideMode.YesCanCollide,
			TilesTransparency.OPAQUE,
			LightSources[0],
			spongeTexture,
			nil,
			nil
		)
	end)
end

return stone_block
