local mult = 1
local tileSize = 16
TileCanvas = {}
--TODO DON4T USE CANVAS FOR HUD TILE CANVAS
function InitializeHUDTileCanvas()
	local atlassSize = finalAtlasSize / tileSize
	for i = 1, atlassSize do
		for j = 1, atlassSize do
			local index = (j - 1) * atlassSize + i
			if not TileCanvas[index] then
				TileCanvas[index] = lovegraphics.newCanvas(tileSize, tileSize)
				lovegraphics.setCanvas(TileCanvas[index])
				lovegraphics.draw(atlasImage, -(i - 1) * tileSize, -(j - 1) * tileSize)
				lovegraphics.setCanvas()
			end
		end
	end
end

function InitializeGameTileCanvas()
	-- create lighting value textures on LightingTexture canvas
	LightValues = 16
	local lightingWidth = finalAtlasSize * LightValues
	LightingTexture = lovegraphics.newCanvas(lightingWidth, finalAtlasSize)
	lovegraphics.setCanvas(LightingTexture)
	lovegraphics.clear(1, 1, 1, 0)
	for i = LightValues, 1, -1 do
		local xx = (i - 1) * finalAtlasSize
		lovegraphics.setColor(mult, mult, mult)
		lovegraphics.draw(atlasImage, xx, 0)
		mult = mult * 0.8
	end
	lovegraphics.setColor(1, 1, 1)
	lovegraphics.setCanvas()
end
