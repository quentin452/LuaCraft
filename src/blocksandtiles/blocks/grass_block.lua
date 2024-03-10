local grassBottomTexture = texturepathLuaCraft .. blocktexturepathLuaCraft .. "grass/grass_bottom.png"
local grassTopTexture = texturepathLuaCraft .. blocktexturepathLuaCraft .. "grass/grass_top.png"
local grassSideTexture = texturepathLuaCraft .. blocktexturepathLuaCraft .. "grass/grass_side.png"
local grass_block = {}

function grass_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"GRASS_Block",
			TileMode.BlockMode,
			CollideMode.YesCanCollide,
			TilesTransparency.OPAQUE,
			LightSources[0],
			grassBottomTexture,
			grassSideTexture,
			grassTopTexture
		)
	end)
end

return grass_block
