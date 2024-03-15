local stone_brickTexture = TexturepathLuaCraft .. BlockTexturepathLuaCraft .. "stone_brick.png"
local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"STONE_BRICK_Block",
			TileMode.BlockMode,
			CollideMode.YesCanCollide,
			TilesTransparency.OPAQUE,
			LightSources[0],
			stone_brickTexture,
			nil,
			nil
		)
	end)
end

return stone_block
