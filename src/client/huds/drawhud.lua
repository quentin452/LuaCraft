function DrawCanevas()
	_JPROFILER.push("DrawCanevas")
	local scale = Lovegraphics.getWidth() / InterfaceWidth
	Lovegraphics.draw(
		Scene.twoCanvas,
		Lovegraphics.getWidth() / 2,
		Lovegraphics.getHeight() / 2 + 1,
		0,
		scale,
		scale,
		InterfaceWidth / 2,
		InterfaceHeight / 2
	)
	_JPROFILER.pop("DrawCanevas")
end

local DrawF3Tab = {
	["Tiles"] = Tiles,
	["ChunkSet"] = ChunkSet,
	["ChunkHashTable"] = ChunkHashTable,
	["CaveList"] = CaveList,
	["ThingList"] = ThingList,
	["TilesTextureFORAtlasList"] = TilesTextureFORAtlasList,
	["RenderChunks"] = RenderChunks,
	["TextureAtlasCoordinates"] = TextureAtlasCoordinates,
	["SliceModels"] = SliceModels,
	["TileModelCaching"] = TileModelCaching,
	["TileTransparencyCache"] = TileTransparencyCache,
	["TileLightSourceCache"] = TileLightSourceCache,
	["TileCollisionCache"] = TileCollisionCache,
}
function DrawF3()
	_JPROFILER.push("DrawF3")
	Lovegraphics.setColor(1, 1, 1)
	local playerPosition = getPlayerPosition()
	Lovegraphics.print("x: " .. playerPosition.x .. "\ny: " .. playerPosition.y .. "\nz: " .. playerPosition.z)
	Lovegraphics.print("Memory Usage: " .. math.floor(collectgarbage("count")) .. " kB", 0, 50)
	Lovegraphics.print("FPS: " .. Lovetimer.getFPS(), 0, 70)
	local playerDirection = GetPlayerDirection(ThePlayer.rotation, ThePlayer.pitch)
	if playerDirection then
		Lovegraphics.print("Direction: " .. playerDirection, 0, 90)
	else
		Lovegraphics.print("Direction: Unknown", 0, 130)
	end

	local yOffset = 150
	for tableName, tableData in pairs(DrawF3Tab) do
		local count = 0
		for _ in pairs(tableData) do
			count = count + 1
		end
		Lovegraphics.print("Number of " .. tableName .. ": " .. count, 0, yOffset)
		yOffset = yOffset + 20
	end

	_JPROFILER.pop("DrawF3")
end

-- Fonction pour obtenir la direction du joueur
local seuilVersLeHaut = Mathpi / 4
local seuilVersLeBas = -Mathpi / 4
function GetPlayerDirection(rotation, pitch)
	_JPROFILER.push("GetPlayerDirection")
	if pitch then
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
		local index = math.floor(((rotation + Mathpi / 8) % (2 * Mathpi)) / (Mathpi / 4)) + 1
		return directions[index]
	end
	_JPROFILER.pop("GetPlayerDirection")
	return nil
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
	if EnableF8 == false and ChunkBorderAlreadyCreated == 1 then
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
	elseif EnableF8 and ChunkBorderAlreadyCreated == 0 then
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

				local chunkBordersModel = Engine.newModel(ChunkVerts, ChunkBorders, coords, color, format)
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

function DrawHudTile(tile, hudX, hudY)
	_JPROFILER.push("DrawHudTile")
	local tileData = GetValueFromTilesById(tile)
	if tile == 0 or not tileData then
		return
	end
	if Tile2DHUD(tile) then
		DrawTileQuad2D(tileData, hudX, hudY, size)
	else
		local textures = { tileData.blockTopTextureUserData, tileData.blockSideTextureUserData }
		if not tileData.blockTopTextureUserData and not tileData.blockSideTextureUserData then
			textures = { tileData.blockBottomMasterTextureUserData, tileData.blockBottomMasterTextureUserData }
		end
		if textures[1] and textures[2] then
			local topQuadVertices, rightFrontQuadVertices, leftSideQuadVertices = CalculateHudVertices(hudX, hudY)
			DrawTileQuadPersonalized(textures[1], topQuadVertices)
			Lovegraphics.setColor(SHADING_FACTOR, SHADING_FACTOR, SHADING_FACTOR)
			DrawTileQuadPersonalized(textures[2], rightFrontQuadVertices)
			Lovegraphics.setColor(SHADING_FACTOR, SHADING_FACTOR, SHADING_FACTOR)
			DrawTileQuadPersonalized(textures[2], leftSideQuadVertices)
		end
	end
	_JPROFILER.pop("DrawHudTile")
end

function DrawTileQuadPersonalized(texture, points)
	_JPROFILER.push("DrawTileQuadPersonalized")
	Perspective.quad(texture, unpack(points))
	_JPROFILER.pop("DrawTileQuadPersonalized")
end

function DrawTileQuad2D(tileData, x, y, size)
	_JPROFILER.push("DrawTileQuad2D")
	local texture = tileData.blockBottomMasterTextureUserData
	if texture then
		local prevFilter = texture:getFilter()
		texture:setFilter("nearest", "nearest")
		Lovegraphics.draw(texture, x + 6, y + 6, 0, size * 2 / texture:getWidth(), size * 2 / texture:getHeight())
		texture:setFilter(prevFilter)
	end
	_JPROFILER.pop("DrawTileQuad2D")
end

function DrawCrossHair()
	_JPROFILER.push("DrawCrossHair")
	-- draw crosshair
	Lovegraphics.setColor(1, 1, 1)
	CrosshairShader:send("source", Scene.threeCanvas)
	CrosshairShader:send("xProportion", 32 / GraphicsWidth)
	CrosshairShader:send("yProportion", 32 / GraphicsHeight)
	Lovegraphics.draw(GuiSprites, GuiCrosshair, InterfaceWidth / 2 - 16, InterfaceHeight / 2 - 16, 0, 2, 2)
	_JPROFILER.pop("DrawCrossHair")
end

function DrawHotBar()
	_JPROFILER.push("DrawHotBar")
	-- draw hotbar
	Lovegraphics.setColor(1, 1, 1)
	Lovegraphics.draw(GuiSprites, GuiHotbarQuad, InterfaceWidth / 2 - 182, InterfaceHeight - 22 * 2, 0, 2, 2)
	Lovegraphics.draw(
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
	if EnableCommandHUD == true then
		if FixinputforDrawCommandInput == false then
			CurrentCommand = ""
			FixinputforDrawCommandInput = true
		end

		-- Dessiner le fond gris transparent
		Lovegraphics.setColor(0.5, 0.5, 0.5, 0.5) -- Gris semi-transparent
		Lovegraphics.rectangle("fill", InterfaceWidth / 2 - 300, InterfaceHeight - 80, 600, 30)

		-- Dessiner la zone de saisie des commandes (rectangle, texte, etc.)
		Lovegraphics.setColor(1, 1, 1)
		Lovegraphics.rectangle("line", InterfaceWidth / 2 - 300, InterfaceHeight - 80, 600, 30)

		-- Dessiner le texte de la commande actuelle
		local cleanedCommand = cleanString(CurrentCommand)

		-- Limiter le texte à la largeur du rectangle
		local maxTextWidth = 600 -- La largeur du rectangle
		while Lovegraphics.getFont():getWidth(cleanedCommand) > maxTextWidth do
			cleanedCommand = cleanedCommand:sub(2) -- Supprimer le premier caractère
		end

		Lovegraphics.print(cleanedCommand, InterfaceWidth / 2 - 300, InterfaceHeight - 75)

		-- Dessiner le curseur
		local cursorX = InterfaceWidth / 2 - 300 + Lovegraphics.getFont():getWidth(cleanedCommand)
		Lovegraphics.line(cursorX, InterfaceHeight - 80, cursorX, InterfaceHeight - 50)
	end
	_JPROFILER.pop("DrawCommandInput")
end

function DrawHudMain()
	if EnableF3 == true then
		DrawF3()
	end

	DrawChunkBorders3D()
	DrawTestBlock()
	DrawCrossHair()

	Lovegraphics.setShader()

	DrawHotBar()

	for i = 1, 9 do
		DrawHudTile(PlayerInventory.items[i], InterfaceWidth / 2 - 182 + 40 * (i - 1), InterfaceHeight - 22 * 2)
	end
	DrawCommandInput()
end
