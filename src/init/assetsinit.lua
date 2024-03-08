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
							textureAtlasCoordinates[blockType] = { index }
						elseif interfacemode == "HUD" then
							textureAtlasCoordinatesFORHUD[blockType] = { index }
						end
						x = x + width
					else
						print("Failed to read file:", texturePath)
					end
				end
			end

			if needResize then
				break
			end

			local loopEndTime = os.clock()
			local loopElapsedTime = loopEndTime - loopStartTime
			print(interfacemode .. " Atlas Time taken in loop: " .. loopElapsedTime .. " seconds")
		until not needResize

		local totalTimeEnd = os.clock()
		local totalTimeElapsed = totalTimeEnd - totalTimeStart
		print(interfacemode .. " Atlas Total time taken: " .. totalTimeElapsed .. " seconds")

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
		print("PNG Atlas Time taken for saving: " .. saveElapsedTime .. " seconds")

		print(
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
	TilesTextureFORAtlasListHUD = {
		--[Tiles.AIR_Block] = airTexture,
		[Tiles.STONE_Block] = { LuaCraftTextures.stoneTexture },
		[Tiles.GRASS_Block] = { LuaCraftTextures.grassTopTexture },
		[Tiles.DIRT_Block] = { LuaCraftTextures.dirtTexture },
		[Tiles.COBBLE_Block] = { LuaCraftTextures.cobbleTexture },
		[Tiles.OAK_PLANK_Block] = { LuaCraftTextures.oak_planksTexture },
		[Tiles.OAK_SAPPLING_Block] = { LuaCraftTextures.oak_sapplingsTexture },
		[Tiles.BEDROCK_Block] = { LuaCraftTextures.bedrockTexture },
		[Tiles.WATER_Block] = { LuaCraftTextures.waterTexture },
		[Tiles.STATIONARY_WATER_Block] = { LuaCraftTextures.waterstationaryTexture },
		[Tiles.LAVA_Block] = { LuaCraftTextures.lavaTexture },
		[Tiles.STATIONARY_LAVA_Block] = { LuaCraftTextures.lavastationaryTexture },
		[Tiles.SAND_Block] = { LuaCraftTextures.sandTexture },
		[Tiles.GRAVEL_Block] = { LuaCraftTextures.gravelTexture },
		[Tiles.GOLD_Block] = { LuaCraftTextures.goldTexture },
		[Tiles.IRON_Block] = { LuaCraftTextures.ironTexture },
		[Tiles.COAL_Block] = { LuaCraftTextures.coalTexture },
		[Tiles.OAK_LOG_Block] = { LuaCraftTextures.oak_logsTopTexture },
		[Tiles.OAK_LEAVE_Block] = { LuaCraftTextures.oak_leavesTexture },
		[Tiles.SPONGE_Block] = { LuaCraftTextures.spongeTexture },
		[Tiles.GLASS_Block] = { LuaCraftTextures.glassTexture },
		[Tiles.ROSE_FLOWER_Block] = { LuaCraftTextures.roseflowerTexture },
		[Tiles.YELLO_FLOWER_Block] = { LuaCraftTextures.yellowflowerTexture },
		[Tiles.STONE_BRICK_Block] = { LuaCraftTextures.stone_brickTexture },
		[Tiles.GLOWSTONE_Block] = { LuaCraftTextures.glowstoneTexture },
	}

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
	TilesTextureFORAtlasListHUDPersonalized = {
		grassTopTexture = LuaCraftTextures.grassTopTexture,
		grassSideTexture = LuaCraftTextures.grassSideTexture,
		oak_logsTopTexture = LuaCraftTextures.oak_logsTopTexture,
		oak_logsSideTexture = LuaCraftTextures.oak_logsSideTexture,
	}
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
			print("This BlockType " .. blockType .. " Has been already registered in TilesTextureListHUD")
		end
	end
end
local function createTILEINGameAssets()
	TilesTextureFORAtlasList = {
		--[Tiles.AIR_Block] = airTexture,
		[Tiles.STONE_Block] = { LuaCraftTextures.stoneTexture },
		[Tiles.GRASS_Block] = {
			LuaCraftTextures.grassTopTexture,
			LuaCraftTextures.grassBottomTexture,
			LuaCraftTextures.grassSideTexture,
		},
		[Tiles.DIRT_Block] = { LuaCraftTextures.dirtTexture },
		[Tiles.COBBLE_Block] = { LuaCraftTextures.cobbleTexture },
		[Tiles.OAK_PLANK_Block] = { LuaCraftTextures.oak_planksTexture },
		[Tiles.OAK_SAPPLING_Block] = { LuaCraftTextures.oak_sapplingsTexture },
		[Tiles.BEDROCK_Block] = { LuaCraftTextures.bedrockTexture },
		[Tiles.WATER_Block] = { LuaCraftTextures.waterTexture },
		[Tiles.STATIONARY_WATER_Block] = { LuaCraftTextures.waterstationaryTexture },
		[Tiles.LAVA_Block] = { LuaCraftTextures.lavaTexture },
		[Tiles.STATIONARY_LAVA_Block] = { LuaCraftTextures.lavastationaryTexture },
		[Tiles.SAND_Block] = { LuaCraftTextures.sandTexture },
		[Tiles.GRAVEL_Block] = { LuaCraftTextures.gravelTexture },
		[Tiles.GOLD_Block] = { LuaCraftTextures.goldTexture },
		[Tiles.IRON_Block] = { LuaCraftTextures.ironTexture },
		[Tiles.COAL_Block] = { LuaCraftTextures.coalTexture },
		[Tiles.OAK_LOG_Block] = {
			LuaCraftTextures.oak_logsTopTexture,
			LuaCraftTextures.oak_logsBottomTexture,
			LuaCraftTextures.oak_logsSideTexture,
		},
		[Tiles.OAK_LEAVE_Block] = { LuaCraftTextures.oak_leavesTexture },
		[Tiles.SPONGE_Block] = { LuaCraftTextures.spongeTexture },
		[Tiles.GLASS_Block] = { LuaCraftTextures.glassTexture },
		[Tiles.ROSE_FLOWER_Block] = { LuaCraftTextures.roseflowerTexture },
		[Tiles.YELLO_FLOWER_Block] = { LuaCraftTextures.yellowflowerTexture },
		[Tiles.STONE_BRICK_Block] = { LuaCraftTextures.stone_brickTexture },
		[Tiles.GLOWSTONE_Block] = { LuaCraftTextures.glowstoneTexture },
	}
	createTextureAtlas("PNG", "INGAME")
	--	TileTexture = lovegraphics.newImage("Atlass/Atlas.png")
	atlasInRAM, TilesTextureList = createTextureAtlas("RAM", "INGAME")
	atlasImage = lovegraphics.newImage(atlasInRAM)
	TilesTextureList = {
		-- textures are in format: UP DOWN FRONT
		-- at least one texture must be present
		[Tiles.GRASS_Block] = { 1, 2, 3 },
		[Tiles.OAK_LOG_Block] = { 18, 19, 20 },
	}
	--REVERT UP DOWN FRONT to be FRONT UP DOWN
	for key, textures in pairs(TilesTextureList) do
		TilesTextureList[key] = { textures[3], textures[1], textures[2] }
	end
	local function blockTypeExists(blockType)
		return TilesTextureList[blockType] ~= nil
	end
	for blockType, _ in pairs(TilesTextureFORAtlasList) do
		if not blockTypeExists(blockType) then
			TilesTextureList[blockType] = { unpack(textureAtlasCoordinates[blockType]) }
		else
			print("This BlockType " .. blockType .. " Has been already registered in TilesTextureList")
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
