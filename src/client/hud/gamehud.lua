--TODO SEE IF HUD DESTROY PERFORMANCES AND IF YES , TRY ADDING A CACHE FOR IT
function drawF3MainGame()
	local w = lg.getDimensions()

	local camX, camY, camZ = g3d.camera.position[1], g3d.camera.position[2], g3d.camera.position[3]
	local fpsText = "FPS: " .. tostring(love.timer.getFPS())

	local coordTextX = w - 150
	local coordTextY = 10

	local fpsTextX = w - 150
	local fpsTextY = 10

	lg.setColor(1, 1, 1)

	lg.print(fpsText, fpsTextX, fpsTextY)

	lg.print("Coordinates :", coordTextX, coordTextY + 20)
	lg.print("X: " .. math.floor(camX), coordTextX, coordTextY + 40)
	lg.print("Y: " .. math.floor(camY), coordTextX, coordTextY + 60)
	lg.print("Z: " .. math.floor(camZ), coordTextX, coordTextY + 80)

	lg.print("Cardinal Points :", coordTextX, coordTextY + 100)

	local cardinalPoints = { "N", "NE", "E", "SE", "S", "SW", "W", "NW" }
	local cameraAngle = math.atan2(g3d.camera.target[2] - camY, g3d.camera.target[1] - camX)
	local index = math.floor((cameraAngle + math.pi / 8) / (math.pi / 4)) % 8 + 1
	local currentCardinalPoint = cardinalPoints[index]

	lg.print("Direction : " .. currentCardinalPoint, coordTextX, coordTextY + 120)
end
