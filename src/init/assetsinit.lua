finalAtlasSize = 256 -- TODO ADD Support for atlas 4096 size and more
textureAtlasCoordinates = {}
textureAtlasCoordinatesFORHUD = {}
--TODO IT SEEM THATS DOESN4T WORK THE ORDER THING
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
	assert(
		finalAtlasSize >= 256 and finalAtlasSize % 256 == 0,
		"finalAtlasSize must be a multiple of 256 and not less than 256"
	)
	local totalTimeStart = os.clock()

	local function mergeTextureLists()
		local mergedList = {}
		for blockType, texturePaths in pairs(TilesTextureFORAtlasList) do
			mergedList[blockType] = (interfacemode == "HUD") and { texturePaths[1] } or texturePaths
		end
		return mergedList
	end

	local TilesTextureList = mergeTextureLists()

	local atlasSize = finalAtlasSize
	local atlas = loveimage.newImageData(atlasSize, atlasSize)
	local x, y = 0, 0

	for _, blockType in ipairs(getKeysInOrder(TilesTextureList)) do
		local texturePaths = TilesTextureList[blockType] or { TilesTextureList[blockType] }

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
					atlasSize = atlasSize + 256
					finalAtlasSize = atlasSize
					local newAtlas = loveimage.newImageData(atlasSize, atlasSize)
					newAtlas:paste(atlas, 0, 0)
					atlas = newAtlas
					x, y = 0, 0
				end

				atlas:paste(imageData, x, y)
				local index = x / 16 + y / 16 * (finalAtlasSize / 16)
				if interfacemode == "INGAME" then
					local ids = BlockThatUseCustomTexturesForTopandSide[blockType]
					textureAtlasCoordinates[blockType] = ids and { index, index - 2, index - 1 } or { index }
				elseif interfacemode == "HUD" then
					textureAtlasCoordinatesFORHUD[blockType] = { index }
				end

				x = x + width
			else
				LuaCraftPrintLoggingNormal("Failed to read file:", texturePath)
			end
		end
	end

	local totalTimeElapsed = os.clock() - totalTimeStart
	LuaCraftPrintLoggingNormal(interfacemode .. " Atlas Total time taken: " .. totalTimeElapsed .. " seconds")

	if memoryorpng == "PNG" then
		local atlasDirectory = "Atlas"
		lovefilesystem.createDirectory(atlasDirectory)
		local atlasImagePath = atlasDirectory .. "/Atlas" .. (interfacemode == "HUD" and "FORHUD" or "") .. ".png"
		local pngData = atlas:encode("png")
		lovefilesystem.write(atlasImagePath, pngData)
	end

	return (interfacemode == "INGAME" and atlas),
		textureAtlasCoordinates or (interfacemode == "HUD" and atlas),
		textureAtlasCoordinatesFORHUD
end

local function createTextureList(textureList, textureCoordinates, atlasMode)
	local textureListResult = {}
	for key, value in pairs(textureList) do
		if not textureListResult[key] then
			local newValue = {}
			if type(value) == "table" then
				for i, v in ipairs(value) do
					newValue[i] = lovegraphics.newImage(v)
				end
			else
				newValue = lovegraphics.newImage(value)
			end
			textureListResult[key] = newValue
		end
	end
	createTextureAtlas("PNG", atlasMode)
	local result = {}
	local function blockTypeExists(blockType)
		return result[blockType] ~= nil
	end
	for blockType, _ in pairs(textureCoordinates) do
		if not blockTypeExists(blockType) then
			result[blockType] = { unpack(textureCoordinates[blockType]) }
		else
			LuaCraftPrintLoggingNormal("This BlockType " .. blockType .. " Has been already registered.")
		end
	end
	return textureListResult, result
end

local function createTILEHUDAssets()
	HUDTilesTextureList, TilesTextureListHUD =
		createTextureList(TilesTextureFORAtlasList, textureAtlasCoordinatesFORHUD, "HUD")
end

local function createTILEINGameAssets()
	createTextureAtlas("PNG", "INGAME")
	local atlasInRAM = createTextureAtlas("RAM", "INGAME")
	atlasImage = lovegraphics.newImage(atlasInRAM)
	TilesTextureList = {}
	for blockType, _ in pairs(textureAtlasCoordinates) do
		if not TilesTextureList[blockType] then
			TilesTextureList[blockType] = { unpack(textureAtlasCoordinates[blockType]) }
		else
			LuaCraftPrintLoggingNormal("This BlockType " .. blockType .. " Has been already registered.")
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
end
