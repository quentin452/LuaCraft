local oak_logsBottomTexture = TexturepathLuaCraft .. BlockTexturepathLuaCraft .. "oak_logs/oak_botton.png"
local oak_logsTopTexture = TexturepathLuaCraft .. BlockTexturepathLuaCraft .. "oak_logs/oak_top.png"
local oak_logsSideTexture = TexturepathLuaCraft .. BlockTexturepathLuaCraft .. "oak_logs/oak_side.png"
local stone_block = {}

function stone_block.initialize()
	addFunctionToTag("addBlock", function()
		addBlock(
			"OAK_LOG_Block",
			TileMode.BlockMode,
			CollideMode.YesCanCollide,
			TilesTransparency.OPAQUE,
			LightSources[0],
			oak_logsBottomTexture,
			Lovegraphics.newImage(oak_logsBottomTexture),
			oak_logsSideTexture,
			Lovegraphics.newImage(oak_logsSideTexture),
			oak_logsTopTexture,
			Lovegraphics.newImage(oak_logsTopTexture)
		)
	end, GetSourcePath())
end

return stone_block
