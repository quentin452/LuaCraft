function DrawCanevas()
	_JPROFILER.push("DrawCanevas")
	local scale = lovegraphics.getWidth() / InterfaceWidth
	lovegraphics.draw(
		Scene.twoCanvas,
		lovegraphics.getWidth() / 2,
		lovegraphics.getHeight() / 2 + 1,
		0,
		scale,
		scale,
		InterfaceWidth / 2,
		InterfaceHeight / 2
	)
	_JPROFILER.pop("DrawCanevas")
end

function DrawF3()
	_JPROFILER.push("DrawF3")
	lovegraphics.setColor(1, 1, 1)
	local playerPosition = getPlayerPosition()
	love.graphics.print("x: " .. playerPosition.x .. "\ny: " .. playerPosition.y .. "\nz: " .. playerPosition.z)
	lovegraphics.print("Memory Usage: " .. math.floor(collectgarbage("count")) .. " kB", 0, 50)
	lovegraphics.print("FPS: " .. lovetimer.getFPS(), 0, 70)
	local playerDirection = GetPlayerDirection(ThePlayer.rotation, ThePlayer.pitch)
	if playerDirection then
		lovegraphics.print("Direction: " .. playerDirection, 0, 90)
	else
		lovegraphics.print("Direction: Unknown", 0, 130)
	end

	local tilescount = 0
	for _ in pairs(Tiles) do
		tilescount = tilescount + 1
	end
	lovegraphics.print("Number of Tiles: " .. tilescount, 0, 150)
	local ChunkSetcount = 0
	for _ in pairs(ChunkSet) do
		ChunkSetcount = ChunkSetcount + 1
	end
	lovegraphics.print("Number of Chunks in ChunkSet: " .. ChunkSetcount, 0, 170)
	local ChunkHashTablecount = 0
	for _ in pairs(ChunkHashTable) do
		ChunkHashTablecount = ChunkHashTablecount + 1
	end
	lovegraphics.print("Number in ChunkHashTable: " .. ChunkHashTablecount, 0, 190)
	local CaveListcount = 0
	for _ in pairs(CaveList) do
		CaveListcount = CaveListcount + 1
	end
	lovegraphics.print("Number in CaveList: " .. CaveListcount, 0, 210)
	local ThingListcount = 0
	for _ in pairs(ThingList) do
		ThingListcount = ThingListcount + 1
	end
	lovegraphics.print("Number in ThingList: " .. ThingListcount, 0, 230)
	local TilesTextureFORAtlasListcount = 0
	for _ in pairs(TilesTextureFORAtlasList) do
		TilesTextureFORAtlasListcount = TilesTextureFORAtlasListcount + 1
	end
	lovegraphics.print("Number in TilesTextureFORAtlasList: " .. TilesTextureFORAtlasListcount, 0, 250)
	local renderChunkscount = 0
	for _ in pairs(renderChunks) do
		renderChunkscount = renderChunkscount + 1
	end
	lovegraphics.print("Number in renderChunks: " .. renderChunkscount, 0, 270)
	local textureAtlasCoordinatescount = 0
	for _ in pairs(textureAtlasCoordinates) do
		textureAtlasCoordinatescount = textureAtlasCoordinatescount + 1
	end
	lovegraphics.print("Number in textureAtlasCoordinates: " .. textureAtlasCoordinatescount, 0, 290)
	local ChunkSliceModelscount = 0
	for _ in pairs(ChunkSliceModels) do
		ChunkSliceModelscount = ChunkSliceModelscount + 1
	end
	lovegraphics.print("Number in ChunkSliceModels: " .. ChunkSliceModelscount, 0, 310)
	local TileModelCachingcount = 0
	for _ in pairs(TileModelCaching) do
		TileModelCachingcount = TileModelCachingcount + 1
	end
	lovegraphics.print("Number in TileModelCaching: " .. TileModelCachingcount, 0, 330)
	_JPROFILER.pop("DrawF3")
end

-- Fonction pour obtenir la direction du joueur
function GetPlayerDirection(rotation, pitch)
	_JPROFILER.push("GetPlayerDirection")
	if pitch then
		local seuilVersLeHaut = mathpi / 4
		local seuilVersLeBas = -mathpi / 4

		if pitch > seuilVersLeHaut then
			_JPROFILER.pop("GetPlayerDirection")
			return "Bas"
		elseif pitch < seuilVersLeBas then
			_JPROFILER.pop("GetPlayerDirection")
			return "Haut"
		end
	end

	if rotation then
		local directions = { "N", "NE", "E", "SE", "S", "SW", "W", "NW", "N" }
		local index = math.floor(((rotation + mathpi / 8) % (2 * mathpi)) / (mathpi / 4)) + 1
		return directions[index]
	end
	_JPROFILER.pop("GetPlayerDirection")
	return nil
end

local exampleModelReference = nil
function DrawTestBlock()
	if enableTESTBLOCK == false and modelalreadycreated == 1 then
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
			end
		end

		chunkBordersModels = {}

		ChunkBorderAlreadyCreated = 0
	elseif enableF8 and ChunkBorderAlreadyCreated == 0 then
		for chunk, _ in pairs(ChunkSet) do
			if type(chunk) == "table" and chunk.x and chunk.y and chunk.z then
				CreateChunkBordersVertices()
				-- No rotation applied, so rotatedVerts is the same as verts
				local rotatedVerts = ChunkVerts

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
	end
end
local TILE_SIZE = 16
local SHADING_FACTOR = 0.8 ^ 2
local ANGLE = 3.14159 / 3
local angleSin = math.sin(ANGLE)
local angleCos = math.cos(ANGLE)
local size = TILE_SIZE
local xsize = angleSin * size
local ysize = angleCos * size
local tileSizePlus6 = TILE_SIZE + 6

local function CalculateHudVertices(hudX, hudY)
	_JPROFILER.push("CalculateHudVertices")
	local x, y = hudX + tileSizePlus6, hudY + tileSizePlus6
	local centerPoint = { x, y }
	local topQuadVertices = {
		{ x, y - size },
		{ x + xsize, y - ysize },
		centerPoint,
		{ x - xsize, y - ysize },
	}
	local rightFrontQuadVertices = {
		centerPoint,
		{ x + xsize, y - ysize },
		{ x + xsize, y + ysize },
		{ x, y + size },
	}
	local leftSideQuadVertices = {
		centerPoint,
		{ x - xsize, y - ysize },
		{ x - xsize, y + ysize },
		{ x, y + size },
	}
	_JPROFILER.pop("CalculateHudVertices")
	return topQuadVertices, rightFrontQuadVertices, leftSideQuadVertices
end

--TODO remove Table_HudTextureCache
local Table_HudTextureCache = {}

function DrawHudTile(tile, hudX, hudY)
	_JPROFILER.push("DrawHudTile")
	local tileData = GetValueFromTilesById(tile)
	if tile == 0 or not tileData then
		return
	end
	if Tile2DHUD(tile) then
		DrawTileQuad2D(tileData, hudX, hudY, size)
	else
		local textures = { tileData.blockTopTexture, tileData.blockSideTexture }
		if not tileData.blockTopTexture and not tileData.blockSideTexture then
			textures = { tileData.blockBottomMasterTexture, tileData.blockBottomMasterTexture }
		end
		if textures[1] and textures[2] then
			local topQuadVertices, rightFrontQuadVertices, leftSideQuadVertices = CalculateHudVertices(hudX, hudY)
			DrawTileQuadPersonalized(textures[1], topQuadVertices)
			lovegraphics.setColor(SHADING_FACTOR, SHADING_FACTOR, SHADING_FACTOR)
			DrawTileQuadPersonalized(textures[2], rightFrontQuadVertices)
			lovegraphics.setColor(SHADING_FACTOR, SHADING_FACTOR, SHADING_FACTOR)
			DrawTileQuadPersonalized(textures[2], leftSideQuadVertices)
		end
	end
	_JPROFILER.pop("DrawHudTile")
end

function DrawTileQuadPersonalized(texture, points)
	_JPROFILER.push("DrawTileQuadPersonalized")
	if not Table_HudTextureCache[texture] then
		Table_HudTextureCache[texture] = lovegraphics.newImage(texture)
	end
	Perspective.quad(Table_HudTextureCache[texture], unpack(points))
	_JPROFILER.pop("DrawTileQuadPersonalized")
end

function DrawTileQuad2D(tileData, x, y, size)
	_JPROFILER.push("DrawTileQuad2D")
	local texture = tileData.blockBottomMasterTexture
	if not Table_HudTextureCache[texture] then
		Table_HudTextureCache[texture] = lovegraphics.newImage(texture)
	end
	local prevFilter = Table_HudTextureCache[texture]:getFilter()
	Table_HudTextureCache[texture]:setFilter("nearest", "nearest")
	lovegraphics.draw(
		Table_HudTextureCache[texture],
		x + 6,
		y + 6,
		0,
		size * 2 / Table_HudTextureCache[texture]:getWidth(),
		size * 2 / Table_HudTextureCache[texture]:getHeight()
	)
	Table_HudTextureCache[texture]:setFilter(prevFilter)
	_JPROFILER.pop("DrawTileQuad2D")
end

function DrawCrossHair()
	_JPROFILER.push("DrawCrossHair")
	-- draw crosshair
	lovegraphics.setColor(1, 1, 1)
	CrosshairShader:send("source", Scene.threeCanvas)
	CrosshairShader:send("xProportion", 32 / GraphicsWidth)
	CrosshairShader:send("yProportion", 32 / GraphicsHeight)
	lovegraphics.draw(GuiSprites, GuiCrosshair, InterfaceWidth / 2 - 16, InterfaceHeight / 2 - 16, 0, 2, 2)
	_JPROFILER.pop("DrawCrossHair")
end

function DrawHotBar()
	_JPROFILER.push("DrawHotBar")
	-- draw hotbar
	lovegraphics.setColor(1, 1, 1)
	lovegraphics.draw(GuiSprites, GuiHotbarQuad, InterfaceWidth / 2 - 182, InterfaceHeight - 22 * 2, 0, 2, 2)
	lovegraphics.draw(
		GuiSprites,
		GuiHotbarSelectQuad,
		InterfaceWidth / 2 - 182 + 40 * (PlayerInventory.hotbarSelect - 1) - 2,
		InterfaceHeight - 24 - 22,
		0,
		2,
		2
	)
	_JPROFILER.pop("DrawHotBar")
end

function cleanString(str)
	_JPROFILER.push("cleanString")
	-- Cette fonction supprime les caractères non valides en UTF-8 de la chaîne donnée
	local cleaned = ""
	for i = 1, #str do
		local c = str:sub(i, i)
		if c:match("[%w%p%s]") then
			cleaned = cleaned .. c
		end
	end
	_JPROFILER.pop("cleanString")
	return cleaned
end

function DrawCommandInput()
	_JPROFILER.push("DrawCommandInput")
	if enableCommandHUD == true then
		if fixinputforDrawCommandInput == false then
			CurrentCommand = ""
			fixinputforDrawCommandInput = true
		end

		-- Dessiner le fond gris transparent
		lovegraphics.setColor(0.5, 0.5, 0.5, 0.5) -- Gris semi-transparent
		lovegraphics.rectangle("fill", InterfaceWidth / 2 - 300, InterfaceHeight - 80, 600, 30)

		-- Dessiner la zone de saisie des commandes (rectangle, texte, etc.)
		lovegraphics.setColor(1, 1, 1)
		lovegraphics.rectangle("line", InterfaceWidth / 2 - 300, InterfaceHeight - 80, 600, 30)

		-- Dessiner le texte de la commande actuelle
		local cleanedCommand = cleanString(CurrentCommand)

		-- Limiter le texte à la largeur du rectangle
		local maxTextWidth = 600 -- La largeur du rectangle
		while lovegraphics.getFont():getWidth(cleanedCommand) > maxTextWidth do
			cleanedCommand = cleanedCommand:sub(2) -- Supprimer le premier caractère
		end

		lovegraphics.print(cleanedCommand, InterfaceWidth / 2 - 300, InterfaceHeight - 75)

		-- Dessiner le curseur
		local cursorX = InterfaceWidth / 2 - 300 + lovegraphics.getFont():getWidth(cleanedCommand)
		lovegraphics.line(cursorX, InterfaceHeight - 80, cursorX, InterfaceHeight - 50)
	end
	_JPROFILER.pop("DrawCommandInput")
end

function FixHudHotbarandTileScaling()
	local scaleCoefficient = 0.7

	InterfaceWidth = lovegraphics.getWidth() * scaleCoefficient
	InterfaceHeight = lovegraphics.getHeight() * scaleCoefficient
end
