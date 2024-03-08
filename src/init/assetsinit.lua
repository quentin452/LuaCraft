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
		local atlas = love.image.newImageData(atlasSize, atlasSize)
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
					local fileExist = love.filesystem.getInfo(texturePath)

					if fileExist then
						local fileData = love.filesystem.read(texturePath)
						local fileDataObject = love.filesystem.newFileData(fileData, texturePath)
						local imageData = love.image.newImageData(fileDataObject)

						local width, height = imageData:getDimensions()

						if x + width > atlasSize then
							x = 0
							y = y + height
						end

						if y + height > atlasSize then
							atlasSize = atlasSize * 2
							finalAtlasSize = atlasSize
							atlas = love.image.newImageData(atlasSize, atlasSize)
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
		love.filesystem.createDirectory(atlasDirectory)

		local saveStartTime = os.clock()
		local atlasImagePath = atlasDirectory .. "/Atlas"
		if interfacemode == "HUD" then
			atlasImagePath = atlasImagePath .. "FORHUD"
		end
		atlasImagePath = atlasImagePath .. ".png"
		local pngData = atlas:encode("png")
		love.filesystem.write(atlasImagePath, pngData)
		local saveEndTime = os.clock()

		local saveElapsedTime = saveEndTime - saveStartTime
		print("PNG Atlas Time taken for saving: " .. saveElapsedTime .. " seconds")

		print(
			"PNG Created "
				.. memoryorpng
				.. ".png at "
				.. love.filesystem.getSaveDirectory()
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
		[Tiles.STONE_Block] = { stoneTexture },
		[Tiles.GRASS_Block] = { grassTopTexture },
		[Tiles.DIRT_Block] = { dirtTexture },
		[Tiles.COBBLE_Block] = { cobbleTexture },
		[Tiles.OAK_PLANK_Block] = { oak_planksTexture },
		[Tiles.OAK_SAPPLING_Block] = { oak_sapplingsTexture },
		[Tiles.BEDROCK_Block] = { bedrockTexture },
		[Tiles.WATER_Block] = { waterTexture },
		[Tiles.STATIONARY_WATER_Block] = { waterstationaryTexture },
		[Tiles.LAVA_Block] = { lavaTexture },
		[Tiles.STATIONARY_LAVA_Block] = { lavastationaryTexture },
		[Tiles.SAND_Block] = { sandTexture },
		[Tiles.GRAVEL_Block] = { gravelTexture },
		[Tiles.GOLD_Block] = { goldTexture },
		[Tiles.IRON_Block] = { ironTexture },
		[Tiles.COAL_Block] = { coalTexture },
		[Tiles.OAK_LOG_Block] = { oak_logsTopTexture },
		[Tiles.OAK_LEAVE_Block] = { oak_leavesTexture },
		[Tiles.SPONGE_Block] = { spongeTexture },
		[Tiles.GLASS_Block] = { glassTexture },
		[Tiles.ROSE_FLOWER_Block] = { roseflowerTexture },
		[Tiles.YELLO_FLOWER_Block] = { yellowflowerTexture },
		[Tiles.STONE_BRICK_Block] = { stone_brickTexture },
		[Tiles.GLOWSTONE_Block] = { glowstoneTexture },
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
		--[Tiles.AIR_Block] = airTexture,
		grassTopTexture = grassTopTexture,
		grassBottomTexture = grassBottomTexture,
		grassSideTexture = grassSideTexture,
		oak_logsTopTexture = oak_logsTopTexture,
		oak_logsBottomTexture = oak_logsBottomTexture,
		oak_logsSideTexture = oak_logsSideTexture,
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
	TilesTextureListHUD = {
		-- textures are in format: UP DOWN FRONT
		-- at least one texture must be present
		--	[Tiles.GRASS_Block] = { 1, 3, 2 },
		--	[Tiles.OAK_LOG_Block] = { 19, 20, 21 },
	}
	--REVERT UP DOWN FRONT to be FRONT UP DOWN
	--	for key, textures in pairs(TilesTextureListHUD) do
	--		TilesTextureListHUD[key] = { textures[3], textures[1], textures[2] }
	--	end
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
		[Tiles.STONE_Block] = { stoneTexture },
		[Tiles.GRASS_Block] = { grassTopTexture, grassBottomTexture, grassSideTexture },
		[Tiles.DIRT_Block] = { dirtTexture },
		[Tiles.COBBLE_Block] = { cobbleTexture },
		[Tiles.OAK_PLANK_Block] = { oak_planksTexture },
		[Tiles.OAK_SAPPLING_Block] = { oak_sapplingsTexture },
		[Tiles.BEDROCK_Block] = { bedrockTexture },
		[Tiles.WATER_Block] = { waterTexture },
		[Tiles.STATIONARY_WATER_Block] = { waterstationaryTexture },
		[Tiles.LAVA_Block] = { lavaTexture },
		[Tiles.STATIONARY_LAVA_Block] = { lavastationaryTexture },
		[Tiles.SAND_Block] = { sandTexture },
		[Tiles.GRAVEL_Block] = { gravelTexture },
		[Tiles.GOLD_Block] = { goldTexture },
		[Tiles.IRON_Block] = { ironTexture },
		[Tiles.COAL_Block] = { coalTexture },
		[Tiles.OAK_LOG_Block] = { oak_logsTopTexture, oak_logsBottomTexture, oak_logsSideTexture },
		[Tiles.OAK_LEAVE_Block] = { oak_leavesTexture },
		[Tiles.SPONGE_Block] = { spongeTexture },
		[Tiles.GLASS_Block] = { glassTexture },
		[Tiles.ROSE_FLOWER_Block] = { roseflowerTexture },
		[Tiles.YELLO_FLOWER_Block] = { yellowflowerTexture },
		[Tiles.STONE_BRICK_Block] = { stone_brickTexture },
		[Tiles.GLOWSTONE_Block] = { glowstoneTexture },
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
	BlockTest = lovegraphics.newImage("resources/assets/textures/debug/defaulttexture.png")
	DefaultTexture = lovegraphics.newImage("resources/assets/textures/debug/defaulttexture.png")
	GuiSprites = lovegraphics.newImage("resources/assets/textures/guis/gui.png")
	mainMenuBackground = lovegraphics.newImage("resources/assets/backgrounds/MainMenuBackground.png")
	mainMenuSettingsBackground = lovegraphics.newImage("resources/assets/backgrounds/Mainmenusettingsbackground.png")
	gameplayingpausemenu = lovegraphics.newImage("resources/assets/backgrounds/gameplayingpausemenu.png")
	playinggamesettings = lovegraphics.newImage("resources/assets/backgrounds/playinggamesettings.png")
	worldCreationBackground = lovegraphics.newImage("resources/assets/backgrounds/WorldCreationBackground.png")
	ChunkBorders = lovegraphics.newImage("resources/assets/textures/debug/chunkborders.png")

	-- Blocks/Tiles/liquids
	grassTopTexture = "resources/assets/textures/blocksandtiles/blocks/grass/grass_top.png"
	grassBottomTexture = "resources/assets/textures/blocksandtiles/blocks/grass/grass_bottom.png"
	grassSideTexture = "resources/assets/textures/blocksandtiles/blocks/grass/grass_side.png"

	airTexture = "resources/assets/textures/blocksandtiles/blocks/air.png"

	bedrockTexture = "resources/assets/textures/blocksandtiles/blocks/bedrock.png"

	coalTexture = "resources/assets/textures/blocksandtiles/blocks/coal.png"

	cobbleTexture = "resources/assets/textures/blocksandtiles/blocks/cobble.png"

	dirtTexture = "resources/assets/textures/blocksandtiles/blocks/dirt.png"

	glassTexture = "resources/assets/textures/blocksandtiles/blocks/glass.png"

	glowstoneTexture = "resources/assets/textures/blocksandtiles/blocks/glowstone.png"

	goldTexture = "resources/assets/textures/blocksandtiles/blocks/gold.png"

	gravelTexture = "resources/assets/textures/blocksandtiles/blocks/gravel.png"

	ironTexture = "resources/assets/textures/blocksandtiles/blocks/iron.png"

	oak_leavesTexture = "resources/assets/textures/blocksandtiles/blocks/oak_leaves.png"

	oak_logsTopTexture = "resources/assets/textures/blocksandtiles/blocks/oak_logs/oak_top.png"
	oak_logsBottomTexture = "resources/assets/textures/blocksandtiles/blocks/oak_logs/oak_botton.png"
	oak_logsSideTexture = "resources/assets/textures/blocksandtiles/blocks/oak_logs/oak_side.png"

	oak_planksTexture = "resources/assets/textures/blocksandtiles/blocks/oak_planks.png"

	sandTexture = "resources/assets/textures/blocksandtiles/blocks/sand.png"

	spongeTexture = "resources/assets/textures/blocksandtiles/blocks/sponge.png"

	stoneTexture = "resources/assets/textures/blocksandtiles/blocks/stone.png"

	stone_brickTexture = "resources/assets/textures/blocksandtiles/blocks/stone_brick.png"

	bedrockTexture = "resources/assets/textures/blocksandtiles/blocks/bedrock.png"

	lavaTexture = "resources/assets/textures/blocksandtiles/liquid/lava.png"

	lavastationaryTexture = "resources/assets/textures/blocksandtiles/liquid/lava_stationary.png"

	waterTexture = "resources/assets/textures/blocksandtiles/liquid/water.png"

	waterstationaryTexture = "resources/assets/textures/blocksandtiles/liquid/water_stationary.png"

	oak_sapplingsTexture = "resources/assets/textures/blocksandtiles/tiles/oak_sapplings.png"

	roseflowerTexture = "resources/assets/textures/blocksandtiles/tiles/rose_flower.png"

	yellowflowerTexture = "resources/assets/textures/blocksandtiles/tiles/yellow_flower.png"
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
