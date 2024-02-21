function drawF3MainGame()
    	-- Affichage des coordonnées et des points cardinaux
		local w, h = love.graphics.getDimensions()
		local font = love.graphics.getFont()

		-- Coordonnées de la caméra
		local camX, camY, camZ = g3d.camera.position[1], g3d.camera.position[2], g3d.camera.position[3]
		love.graphics.setColor(1, 1, 1)
		love.graphics.print("Coordonnées :", w - 150, 10)
		love.graphics.print("X: " .. math.floor(camX), w - 150, 30)
		love.graphics.print("Y: " .. math.floor(camY), w - 150, 50)
		love.graphics.print("Z: " .. math.floor(camZ), w - 150, 70)

		-- Coordonnées de la cible de la caméra (où le joueur regarde)
		local targetX, targetY, targetZ = g3d.camera.target[1], g3d.camera.target[2], g3d.camera.target[3]
		--love.graphics.print("Regarde vers :", w - 150, 90)
		-- love.graphics.print("X: " .. math.floor(targetX), w - 150, 110)
		--love.graphics.print("Y: " .. math.floor(targetY), w - 150, 130)
		-- love.graphics.print("Z: " .. math.floor(targetZ), w - 150, 150)

		-- Points cardinaux
		love.graphics.print("Points cardinaux :", w - 150, 170)
		local cardinalPoints = { "N", "NE", "E", "SE", "S", "SW", "W", "NW" }
		local cameraAngle = math.atan2(targetY - camY, targetX - camX)
		local index = math.floor((cameraAngle + math.pi / 8) / (math.pi / 4)) % 8 + 1
		local currentCardinalPoint = cardinalPoints[index]
		love.graphics.print("Direction : " .. currentCardinalPoint, w - 150, 190)
end