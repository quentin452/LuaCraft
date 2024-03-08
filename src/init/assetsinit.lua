finalAtlasSize = 256 -- TODO ADD Support for atlas 4096 size and more
textureAtlasCoordinates = {}
textureAtlasCoordinatesFORHUD = {}
local function getKeysInOrder(tbl)
	_JPROFILER.push("getKeysInOrder")
	local keys = {}
	for k, _ in pairs(tbl) do
		table.insert(keys, k)
	end
	table.sort(keys)
	_JPROFILER.pop("getKeysInOrder")
	return keys
end
--TODO REDUCE TIME TO SAVE ATLAS IF THE ATLAS IS TOO MUCH LARGER
--TODO ADD EASY texture size changer (for now only support 16x16)
local function createTextureAtlas(memoryorpng, interfacemode)
	local totalTimeStart = os.clock()

	if finalAtlasSize < 256 or finalAtlasSize % 256 ~= 0 then
		error("finalAtlasSize must be a multiple of 256 and not less than 256")
	end

	local TilesTextureList

	if interfacemode == "INGAME" then
		TilesTextureList = TilesTextureFORAtlasList
	elseif interfacemode == "HUD" then
		TilesTextureList = TilesTextureFORAtlasListHUD
	else
		error("Invalid mode specified")
	end

	local function initializeAtlas(atlasSize)
		local atlas = loveimage.newImageData(atlasSize, atlasSize)
		local x, y = 0, 0
		local needResize = false

		repeat
			local loopStartTime = os.clock()

			local orderedKeys = getKeysInOrder(TilesTextureList)

			for _, blockType in ipairs(orderedKeys) do
				local texturePaths = TilesTextureList[blockType]
				if type(texturePaths) ~= "table" then
					texturePaths = { texturePaths }
				end

				for _, texturePath in ipairs(texturePaths) do
					local fileExist = lovefilesystem.getInfo(texturePath)

					if fileExist then
						local fileData = lovefilesystem.read(texturePath)
						local fileDataObject = lovefilesystem.newFileData(fileData, texturePath)
						local imageData = loveimage.newImageData(fileDataObject)

						local width, height = imageData:getDimensions()

						if x + width > atlasSize then
							x = 0
							y = y + height
						end

						if y + height > atlasSize then
							atlasSize = atlasSize * 2
							finalAtlasSize = atlasSize
							atlas = loveimage.newImageData(atlasSize, atlasSize)
							x, y = 0, 0
							textureAtlasCoordinates = {}
							textureAtlasCoordinatesFORHUD = {}
							needResize = true
							break
						else
							needResize = false
						end

						atlas:paste(imageData, x, y)

						local tileWidth, tileHeight = 16, 16
						local index = x / tileWidth + y / tileHeight * (finalAtlasSize / tileHeight)

						if interfacemode == "INGAME" then
							--TODO ADD MOD SUPPORT TILES CATEGORY
							if blockType == Tiles.GRASS_Block or blockType == Tiles.OAK_LOG_Block then
								textureAtlasCoordinates[blockType] = { index, index - 2, index - 1 }
							else
								textureAtlasCoordinates[blockType] = { index }
							end
						elseif interfacemode == "HUD" then
							textureAtlasCoordinatesFORHUD[blockType] = { index }
						end

						x = x + width
					else
						LuaCraftPrintLoggingNormal("Failed to read file:", texturePath)
					end
				end
			end

			if needResize then
				break
			end

			local loopEndTime = os.clock()
			local loopElapsedTime = loopEndTime - loopStartTime
			LuaCraftPrintLoggingNormal(interfacemode .. " Atlas Time taken in loop: " .. loopElapsedTime .. " seconds")
		until not needResize

		local totalTimeEnd = os.clock()
		local totalTimeElapsed = totalTimeEnd - totalTimeStart
		LuaCraftPrintLoggingNormal(interfacemode .. " Atlas Total time taken: " .. totalTimeElapsed .. " seconds")

		return atlas
	end

	local atlasSize = finalAtlasSize
	local atlas = initializeAtlas(atlasSize)

	if memoryorpng == "PNG" then
		local atlasDirectory = "Atlas"
		lovefilesystem.createDirectory(atlasDirectory)

		local saveStartTime = os.clock()
		local atlasImagePath = atlasDirectory .. "/Atlas"
		if interfacemode == "HUD" then
			atlasImagePath = atlasImagePath .. "FORHUD"
		end
		atlasImagePath = atlasImagePath .. ".png"
		local pngData = atlas:encode("png")
		lovefilesystem.write(atlasImagePath, pngData)
		local saveEndTime = os.clock()

		local saveElapsedTime = saveEndTime - saveStartTime
		LuaCraftPrintLoggingNormal("PNG Atlas Time taken for saving: " .. saveElapsedTime .. " seconds")

		LuaCraftPrintLoggingNormal(
			"PNG Created "
				.. memoryorpng
				.. ".png at "
				.. lovefilesystem.getSaveDirectory()
				.. "/"
				.. atlasDirectory
				.. " with size "
				.. atlasSize
		)
	end

	if interfacemode == "INGAME" then
		return atlas, textureAtlasCoordinates
	elseif interfacemode == "HUD" then
		return atlas, nil, textureAtlasCoordinatesFORHUD
	end
end

local function createTILEHUDAssets()
	TilesTextureFORAtlasListHUD = {}
	for k, v in pairs(TilesTextureFORAtlasList) do
		TilesTextureFORAtlasListHUD[k] = { v[1] }
	end
	HUDTilesTextureList = {}
	for key, value in pairs(TilesTextureFORAtlasListHUD) do
		if HUDTilesTextureList[key] == nil then
			if type(value) == "table" then
				local newValue = {}
				for i, v in ipairs(value) do
					newValue[i] = lovegraphics.newImage(v)
				end
				HUDTilesTextureList[key] = newValue
			else
				HUDTilesTextureList[key] = lovegraphics.newImage(value)
			end
		end
	end

	HUDTilesTextureListPersonalized = {}
	for key, value in pairs(TilesTextureFORAtlasListHUDPersonalized) do
		if HUDTilesTextureListPersonalized[key] == nil then
			if type(value) == "table" then
				local newValue = {}
				for i, v in ipairs(value) do
					newValue[i] = lovegraphics.newImage(v)
				end
				HUDTilesTextureListPersonalized[key] = newValue
			else
				HUDTilesTextureListPersonalized[key] = lovegraphics.newImage(value)
			end
		end
	end
	createTextureAtlas("PNG", "HUD")
	TilesTextureListHUD = {}
	local function blockTypeExists(blockType)
		return TilesTextureListHUD[blockType] ~= nil
	end
	for blockType, _ in pairs(TilesTextureFORAtlasListHUD) do
		if not blockTypeExists(blockType) then
			TilesTextureListHUD[blockType] = { unpack(textureAtlasCoordinatesFORHUD[blockType]) }
		else
			LuaCraftPrintLoggingNormal(
				"This BlockType " .. blockType .. " Has been already registered in TilesTextureListHUD"
			)
		end
	end
end
local function createTILEINGameAssets()
	createTextureAtlas("PNG", "INGAME")
	atlasInRAM, TilesTextureList = createTextureAtlas("RAM", "INGAME")
	atlasImage = lovegraphics.newImage(atlasInRAM)
	TilesTextureList = {}

	local function blockTypeExists(blockType)
		return TilesTextureList[blockType] ~= nil
	end
	for blockType, _ in pairs(textureAtlasCoordinates) do
		if not blockTypeExists(blockType) then
			TilesTextureList[blockType] = { unpack(textureAtlasCoordinates[blockType]) }
		else
			LuaCraftPrintLoggingNormal(
				"This BlockType " .. blockType .. " Has been already registered in TilesTextureList"
			)
		end
	end
end

local function InitializeImages()
	local texturepath = "resources/assets/textures/"
	-- Load images
	BlockTest = lovegraphics.newImage(texturepath .. "debug/defaulttexture.png")
	DefaultTexture = BlockTest -- Reuse the same image reference
	GuiSprites = lovegraphics.newImage(texturepath .. "guis/gui.png")
	mainMenuBackground = lovegraphics.newImage("resources/assets/backgrounds/MainMenuBackground.png")
	mainMenuSettingsBackground = lovegraphics.newImage("resources/assets/backgrounds/Mainmenusettingsbackground.png")
	playingGamePauseMenu = lovegraphics.newImage("resources/assets/backgrounds/gameplayingpausemenu.png")
	playingGameSettings = lovegraphics.newImage("resources/assets/backgrounds/playinggamesettings.png")
	worldCreationBackground = lovegraphics.newImage("resources/assets/backgrounds/WorldCreationBackground.png")
	ChunkBorders = lovegraphics.newImage(texturepath .. "debug/chunkborders.png")
end
local function finalCheckAssets()
	for key, value in pairs(HUDTilesTextureList) do
		if #value > 1 then
			error(
				"Block with several textures detected in HUDTilesTextureList: "
					.. key
					.. " this table only accept one texture per block"
			)
		end
	end
	for key, value in pairs(TilesTextureFORAtlasListHUD) do
		if #value > 1 then
			error(
				"Block with several textures detected in  TilesTextureFORAtlasListHUD: "
					.. key
					.. " this table only accept one texture per block"
			)
		end
	end
end

function InitializeAssets()
	_JPROFILER.push("InitializeTilesNumberAndName")
	InitializeTilesNumberAndName()
	_JPROFILER.pop("InitializeTilesNumberAndName")
	_JPROFILER.push("InitalizeTextureStatic")
	InitalizeTextureStatic()
	_JPROFILER.pop("InitalizeTextureStatic")
	_JPROFILER.push("InitializeImages")
	InitializeImages()
	_JPROFILER.pop("InitializeImages")
	_JPROFILER.push("createTILEINGameAssets")
	createTILEINGameAssets()
	_JPROFILER.pop("createTILEINGameAssets")
	_JPROFILER.push("createTILEHUDAssets")
	createTILEHUDAssets()
	_JPROFILER.pop("createTILEHUDAssets")
	_JPROFILER.push("finalCheckAssets")
	finalCheckAssets()
	_JPROFILER.pop("finalCheckAssets")
end
