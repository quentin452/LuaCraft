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
	love.graphics.setColor(1, 1, 1)
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

	local playerDirection = GetPlayerDirection(ThePlayer.rotation, ThePlayer.pitch)
	if playerDirection then
		love.graphics.print("Direction: " .. playerDirection, 0, 130)
	else
		love.graphics.print("Direction: Unknown", 0, 130)
	end
end

-- Fonction pour obtenir la direction du joueur
function GetPlayerDirection(rotation, pitch)
	if pitch then
		local seuilVersLeHaut = math.pi / 4
		local seuilVersLeBas = -math.pi / 4

		if pitch > seuilVersLeHaut then
			return "Bas"
		elseif pitch < seuilVersLeBas then
			return "Haut"
		end
	end

	if rotation then
		local directions = { "N", "NE", "E", "SE", "S", "SW", "W", "NW", "N" }
		local index = math.floor(((rotation + math.pi / 8) % (2 * math.pi)) / (math.pi / 4)) + 1
		return directions[index]
	end

	return nil
end

local exampleModelReference = nil
function DrawTestBlock()
	if enableTESTBLOCK == false and modelalreadycreated == 1 then
		LuaCraftPrintLoggingNormal("[NORMAL LOGGING] Condition met. Disabling test block and removing model...")
		if exampleModelReference then
			-- Trouver l'indice du modèle dans la liste
			local modelIndex = nil
			for i, model in ipairs(scene.modelList) do
				if model == exampleModelReference then
					modelIndex = i
					break
				end
			end

			-- Retirer le modèle de la liste
			if modelIndex then
				table.remove(scene.modelList, modelIndex)
				LuaCraftPrintLoggingNormal("Model removed.")
			end

			exampleModelReference = nil
			modelalreadycreated = 0
			LuaCraftPrintLoggingNormal("modelalreadycreated reset to 0")
		end
		LuaCraftPrintLoggingNormal("modelalreadycreated")
	elseif enableTESTBLOCK and modelalreadycreated == 0 then
		if modelalreadycreated == 1 then
			return
		end
		-- Example usage of engine.newModel
		local verts = {
			-- Face avant
			{ 0, 0, 0 },
			{ 1, 0, 0 },
			{ 1, 1, 0 },
			{ 1, 1, 0 },
			{ 0, 1, 0 },
			{ 0, 0, 0 },

			-- Face arrière
			{ 0, 0, 1 },
			{ 1, 0, 1 },
			{ 1, 1, 1 },
			{ 1, 1, 1 },
			{ 0, 1, 1 },
			{ 0, 0, 1 },

			-- Face gauche
			{ 0, 0, 0 },
			{ 0, 1, 0 },
			{ 0, 1, 1 },
			{ 0, 1, 1 },
			{ 0, 0, 1 },
			{ 0, 0, 0 },

			-- Face droite
			{ 1, 0, 0 },
			{ 1, 1, 0 },
			{ 1, 1, 1 },
			{ 1, 1, 1 },
			{ 1, 0, 1 },
			{ 1, 0, 0 },

			-- Face supérieure
			{ 0, 1, 0 },
			{ 1, 1, 0 },
			{ 1, 1, 1 },
			{ 1, 1, 1 },
			{ 0, 1, 1 },
			{ 0, 1, 0 },

			-- Face inférieure
			{ 0, 0, 0 },
			{ 1, 0, 0 },
			{ 1, 0, 1 },
			{ 1, 0, 1 },
			{ 0, 0, 1 },
			{ 0, 0, 0 },
		}
		local x = 0
		local y = 120
		local z = 0
		local coords = { x, y, z }
		local color = { 1, 1, 1 }
		local format = {
			{ "VertexPosition", "float", 3 },
			{ "VertexTexCoord", "float", 2 },
		}

		local t = NewThing(x, y, z)
		t.name = "BlockTest"

		myModel = engine.newModel(verts, BlockTest, coords, color, format)
		myModel.culling = false

		t:assignModel(myModel)

		exampleModelReference = myModel
		modelalreadycreated = 1
		LuaCraftPrintLoggingNormal("DrawTestBlock completed.")
	end
end
local function CreateChunkBordersVertices()
	ChunkVerts = {
		-- Bottom face
		{ 0, 0, 0 },
		{ ChunkSize, 0, 0 },
		{ ChunkSize, 0, ChunkSize },
		{ ChunkSize, 0, ChunkSize },
		{ 0, 0, ChunkSize },
		{ 0, 0, 0 },

		-- Top face
		{ 0, WorldHeight, 0 },
		{ ChunkSize, WorldHeight, 0 },
		{ ChunkSize, WorldHeight, ChunkSize },
		{ ChunkSize, WorldHeight, ChunkSize },
		{ 0, WorldHeight, ChunkSize },
		{ 0, WorldHeight, 0 },

		-- Front face
		{ 0, 0, 0 },
		{ ChunkSize, 0, 0 },
		{ ChunkSize, WorldHeight, 0 },
		{ ChunkSize, WorldHeight, 0 },
		{ 0, WorldHeight, 0 },
		{ 0, 0, 0 },

		-- Back face
		{ 0, 0, ChunkSize },
		{ ChunkSize, 0, ChunkSize },
		{ ChunkSize, WorldHeight, ChunkSize },
		{ ChunkSize, WorldHeight, ChunkSize },
		{ 0, WorldHeight, ChunkSize },
		{ 0, 0, ChunkSize },

		-- Left face
		{ 0, 0, 0 },
		{ 0, 0, ChunkSize },
		{ 0, WorldHeight, ChunkSize },
		{ 0, WorldHeight, ChunkSize },
		{ 0, WorldHeight, 0 },
		{ 0, 0, 0 },

		-- Right face
		{ ChunkSize, 0, 0 },
		{ ChunkSize, 0, ChunkSize },
		{ ChunkSize, WorldHeight, ChunkSize },
		{ ChunkSize, WorldHeight, ChunkSize },
		{ ChunkSize, WorldHeight, 0 },
		{ ChunkSize, 0, 0 },
	}
end
local chunkBordersModels = {}
function DrawChunkBorders3D()
	if enableF8 == false and ChunkBorderAlreadyCreated == 1 then
		LuaCraftPrintLoggingNormal("[NORMAL LOGGING] Condition met. Disabling test block and removing models...")

		-- Supprimer tous les modèles de la liste
		for _, model in ipairs(chunkBordersModels) do
			local modelIndex = nil
			for i, sceneModel in ipairs(scene.modelList) do
				if sceneModel == model then
					modelIndex = i
					break
				end
			end

			if modelIndex then
				table.remove(scene.modelList, modelIndex)
				LuaCraftPrintLoggingNormal("Model removed.")
			end
		end

		chunkBordersModels = {} -- Réinitialiser la table des modèles

		ChunkBorderAlreadyCreated = 0
		LuaCraftPrintLoggingNormal("ChunkBorderAlreadyCreated reset to 0")
		LuaCraftPrintLoggingNormal("Models removed.")
	elseif enableF8 and ChunkBorderAlreadyCreated == 0 then
		for chunk, _ in pairs(ChunkSet) do
			LuaCraftPrintLoggingNormal("test1")
			if type(chunk) == "table" and chunk.x and chunk.y and chunk.z then
				LuaCraftPrintLoggingNormal("test2")

				CreateChunkBordersVertices()
				-- No rotation applied, so rotatedVerts is the same as verts
				local rotatedVerts = ChunkVerts

				-- Debugging output
				for i, v in ipairs(rotatedVerts) do
					LuaCraftPrintLoggingNormal(
						"After Rotation - Vertex "
							.. i
							.. ": x = "
							.. rotatedVerts[i][1]
							.. ", y = "
							.. rotatedVerts[i][2]
							.. ", z = "
							.. rotatedVerts[i][3]
					)
				end

				-- Update verts with rotatedVerts
				ChunkVerts = rotatedVerts

				local x = (chunk.x - 1) * ChunkSize
				local y = chunk.y
				local z = (chunk.z - 1) * ChunkSize
				local coords = { x, y, z }
				local color = { 1, 1, 1 }
				local format = {
					{ "VertexPosition", "float", 3 },
					{ "VertexTexCoord", "float", 2 },
				}

				-- Print debugging information
				LuaCraftPrintLoggingNormal("Chunk Borders Debugging:")
				LuaCraftPrintLoggingNormal("World Height: " .. WorldHeight)

				-- Print chunk coordinates
				LuaCraftPrintLoggingNormal("Chunk Coordinates: x = " .. x .. ", y = " .. y .. ", z = " .. z)

				-- Print vertices
				for i, v in ipairs(ChunkVerts) do
					LuaCraftPrintLoggingNormal(
						"Vertex " .. i .. ": x = " .. v[1] .. ", y = " .. v[2] .. ", z = " .. v[3]
					)
				end

				local t = NewThing(x, y, z)
				t.name = "ChunkBorders"

				local chunkBordersModel = engine.newModel(ChunkVerts, ChunkBorders, coords, color, format)
				chunkBordersModel.culling = false

				t:assignModel(chunkBordersModel)

				-- Ajouter le modèle à la table
				table.insert(chunkBordersModels, chunkBordersModel)
			end
		end

		ChunkBorderAlreadyCreated = 1
		LuaCraftPrintLoggingNormal("DrawChunkBorders3D completed.")
	end
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
