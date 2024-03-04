function InitializeHUDTileCanvas()
    TileCanvas = {}
    local tileSize = 16
    for i = 1, 16 do
        local xx = (i - 1) * tileSize
        for j = 1, 16 do
            local yy = (j - 1) * tileSize
            local index = (j - 1) * 16 + i
            TileCanvas[index] = lovegraphics.newCanvas(tileSize, tileSize)
            local this = TileCanvas[index]
            lovegraphics.setCanvas(this)
            lovegraphics.draw(TileTexture, -xx, -yy)
        end
    end
end

function InitializeGameTileCanvas()
	-- create lighting value textures on LightingTexture canvas
	LightValues = 16
	local width, height = TileTexture:getWidth(), TileTexture:getHeight()
	LightingTexture = love.graphics.newCanvas(width * LightValues, height)
	local mult = 1
	lovegraphics.setCanvas(LightingTexture)
	lovegraphics.clear(1, 1, 1, 0)
	for i = LightValues, 1, -1 do
		local xx = (i - 1) * width
		lovegraphics.setColor(mult, mult, mult)
		lovegraphics.draw(TileTexture, xx, 0)
		mult = mult * 0.8
	end
    lovegraphics.setColor(1, 1, 1)
	lovegraphics.setCanvas()
end
