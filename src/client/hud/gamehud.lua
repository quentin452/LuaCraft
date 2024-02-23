function drawF3MainGame()
	local w = love.graphics.getDimensions()

	local camX, camY, camZ = g3d.camera.position[1], g3d.camera.position[2], g3d.camera.position[3]
	local fpsText = "FPS: " .. tostring(love.timer.getFPS())

	local coordTextX = w - 150
	local coordTextY = 10

	local fpsTextX = w - 150
	local fpsTextY = 10

	love.graphics.setColor(1, 1, 1)

	love.graphics.print(fpsText, fpsTextX, fpsTextY)

	love.graphics.print("Coordinates :", coordTextX, coordTextY + 20)
	love.graphics.print("X: " .. math.floor(camX), coordTextX, coordTextY + 40)
	love.graphics.print("Y: " .. math.floor(camY), coordTextX, coordTextY + 60)
	love.graphics.print("Z: " .. math.floor(camZ), coordTextX, coordTextY + 80)

	love.graphics.print("Cardinal Points :", coordTextX, coordTextY + 100)

	local cardinalPoints = { "N", "NE", "E", "SE", "S", "SW", "W", "NW" }
	local cameraAngle = math.atan2(g3d.camera.target[2] - camY, g3d.camera.target[1] - camX)
	local index = math.floor((cameraAngle + math.pi / 8) / (math.pi / 4)) % 8 + 1
	local currentCardinalPoint = cardinalPoints[index]

	love.graphics.print("Direction : " .. currentCardinalPoint, coordTextX, coordTextY + 120)
end
