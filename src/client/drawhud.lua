function DrawCanevas()
    local scale = love.graphics.getWidth() / InterfaceWidth
	love.graphics.draw(
		Scene.twoCanvas,
		love.graphics.getWidth() / 2,
		love.graphics.getHeight() / 2 + 1,
		0,
		scale,
		scale,
		InterfaceWidth / 2,
		InterfaceHeight / 2
	)
end

function DrawF3()
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(
        "x: "
            .. math.floor(ThePlayer.x + 0.5)
            .. "\ny: "
            .. math.floor(ThePlayer.y + 0.5)
            .. "\nz: "
            .. math.floor(ThePlayer.z + 0.5)
    )
    local chunk, cx, cy, cz, hashx, hashy = GetChunk(ThePlayer.x, ThePlayer.y, ThePlayer.z)
    if chunk ~= nil then
        love.graphics.print("kB: " .. math.floor(collectgarbage("count")), 0, 50)
    end
    love.graphics.print("FPS: " .. love.timer.getFPS(), 0, 70)
    love.graphics.print("#LightingQueue: " .. #LightingQueue, 0, 90)
    love.graphics.print("#LightingRQueue: " .. #LightingRemovalQueue, 0, 110)
    --love.graphics.print("Press 'V' to toggle VSync", 0, 90)
    --love.graphics.print("#ThingList: " .. #ThingList, 0, 130)
    --for i = 1, #ThingList do
    --	love.graphics.print(ThingList[i].name, 10, 100 + i * 130)
    --end
end

function DrawHudTile(tile, x, y)
	-- Preload TileTextures
	local textures = TileTextures(tile)

	if tile == 0 or not textures then
		return
	end

	local x, y = x + 16 + 6, y + 16 + 6
	local size = 16
	local xsize = math.sin(3.14159 / 3) * 16
	local ysize = math.cos(3.14159 / 3) * 16

	local centerPoint = { x, y }

	-- textures are in format: SIDE UP DOWN FRONT
	-- top
	Perspective.quad(
		TileCanvas[textures[math.min(#textures, 2)] + 1],
		{ x, y - size },
		{ x + xsize, y - ysize },
		centerPoint,
		{ x - xsize, y - ysize }
	)

	-- right side front
	local shade1 = 0.8 ^ 3
	love.graphics.setColor(shade1, shade1, shade1)
	local index = (#textures == 4) and 4 or 1
	Perspective.quad(
		TileCanvas[textures[index] + 1],
		centerPoint,
		{ x + xsize, y - ysize },
		{ x + xsize, y + ysize },
		{ x, y + size }
	)

	-- left side side
	local shade2 = 0.8 ^ 2
	love.graphics.setColor(shade2, shade2, shade2)
	Perspective.flip = true
	Perspective.quad(
		TileCanvas[textures[1] + 1],
		centerPoint,
		{ x - xsize, y - ysize },
		{ x - xsize, y + ysize },
		{ x, y + size }
	)
	Perspective.flip = false
end

function DrawCrossHair()
		-- draw crosshair
		love.graphics.setColor(1, 1, 1)
		CrosshairShader:send("source", Scene.threeCanvas)
		CrosshairShader:send("xProportion", 32 / GraphicsWidth)
		CrosshairShader:send("yProportion", 32 / GraphicsHeight)
		love.graphics.setShader(CrosshairShader)

		-- draw crosshair
		love.graphics.setColor(1, 1, 1)
		CrosshairShader:send("source", Scene.threeCanvas)
		CrosshairShader:send("xProportion", 32 / GraphicsWidth)
		CrosshairShader:send("yProportion", 32 / GraphicsHeight)
		love.graphics.draw(GuiSprites, GuiCrosshair, InterfaceWidth / 2 - 16, InterfaceHeight / 2 - 16, 0, 2, 2)
end

function DrawHotBar()
	-- draw hotbar
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(GuiSprites, GuiHotbarQuad, InterfaceWidth / 2 - 182, InterfaceHeight - 22 * 2, 0, 2, 2)
    love.graphics.draw(
        GuiSprites,
        GuiHotbarSelectQuad,
        InterfaceWidth / 2 - 182 + 40 * (PlayerInventory.hotbarSelect - 1) - 2,
        InterfaceHeight - 24 - 22,
        0,
        2,
        2
    )
end