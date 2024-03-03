function InitializeTileCanevas()
    TileCanvas = {}
    local tileSize = 16
    for i = 1, 16 do
        local xx = (i - 1) * tileSize
        for j = 1, 16 do
            local yy = (j - 1) * tileSize
            local index = (j - 1) * 16 + i
            TileCanvas[index] = love.graphics.newCanvas(tileSize, tileSize)
            local this = TileCanvas[index]
            love.graphics.setCanvas(this)
            love.graphics.draw(TileTexture, -xx, -yy)
        end
    end
end

function InitalizeLightningCanevas()
	-- create lighting value textures on LightingTexture canvas
	LightValues = 16
	local width, height = TileTexture:getWidth(), TileTexture:getHeight()
	LightingTexture = love.graphics.newCanvas(width * LightValues, height)
	local mult = 1
	love.graphics.setCanvas(LightingTexture)
	love.graphics.clear(1, 1, 1, 0)
	for i = LightValues, 1, -1 do
		local xx = (i - 1) * width
		love.graphics.setColor(mult, mult, mult)
		love.graphics.draw(TileTexture, xx, 0)
		mult = mult * 0.8
	end
    love.graphics.setColor(1, 1, 1)
	love.graphics.setCanvas()
end
