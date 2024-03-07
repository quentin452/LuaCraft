function InitializeAssets()
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
	grassBottomTexture = "resources/assets/textures/blocksandtiles/blocks/grass/grass_side.png"
	grassSideTexture = "resources/assets/textures/blocksandtiles/blocks/grass/grass_botton.png"

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

	TilesTextureAtlasList = {
		[Tiles.AIR_Block] = airTexture,
		[Tiles.STONE_Block] = stoneTexture,
		[Tiles.GRASS_Block] = { grassTopTexture, grassBottomTexture, grassSideTexture },
		[Tiles.DIRT_Block] = dirtTexture,
		[Tiles.COBBLE_Block] = cobbleTexture,
		[Tiles.OAK_PLANK_Block] = oak_planksTexture,
		[Tiles.OAK_SAPPLING_Block] = oak_sapplingsTexture,
		[Tiles.BEDROCK_Block] = bedrockTexture,
		[Tiles.WATER_Block] = waterTexture,
		[Tiles.STATIONARY_WATER_Block] = waterstationaryTexture,
		[Tiles.LAVA_Block] = lavaTexture,
		[Tiles.STATIONARY_LAVA_Block] = lavastationaryTexture,
		[Tiles.SAND_Block] = sandTexture,
		[Tiles.GRAVEL_Block] = gravelTexture,
		[Tiles.GOLD_Block] = goldTexture,
		[Tiles.IRON_Block] = ironTexture,
		[Tiles.COAL_Block] = coalTexture,
		[Tiles.OAK_LOG_Block] = { oak_logsTopTexture, oak_logsBottomTexture, oak_logsSideTexture },
		[Tiles.OAK_LEAVE_Block] = oak_leavesTexture,
		[Tiles.SPONGE_Block] = spongeTexture,
		[Tiles.GLASS_Block] = glassTexture,
		[Tiles.ROSE_FLOWER_Block] = roseflowerTexture,
		[Tiles.YELLO_FLOWER_Block] = yellowflowerTexture,
		[Tiles.STONE_BRICK_Block] = stone_brickTexture,
		[Tiles.GLOWSTONE_Block] = glowstoneTexture,
	}
	createTextureAtlas()
	TileTexture = lovegraphics.newImage("Atlass/Atlas.png")
	TilesTextureList = {
		-- textures are in format: FRONT UP DOWN
		-- at least one texture must be present
		--TODO SUPPORT MULTIPLE TEXTURES FOR GRASS_Block ,OAK_LOG_Block by example using textureAtlassCoordinates
		[Tiles.GRASS_Block] = { 2, 1, 3 },
		[Tiles.OAK_LOG_Block] = { 21, 19, 20 },
	}
	local function blockTypeExists(blockType)
		return TilesTextureList[blockType] ~= nil
	end
	for blockType, _ in pairs(TilesTextureAtlasList) do
		if not blockTypeExists(blockType) then
			TilesTextureList[blockType] = { unpack(textureAtlassCoordinates[blockType]) }
		else
			print("This BlockType " .. blockType .. " Has been already registered in TilesTextureList")
		end
	end
end
--TODO REDUCE TIME TO SAVE ATLAS IF THE ATLAS IS TOO MUCH LARGER
--TODO ADD EASY texture size changer (for now only support 16x16)
finalAtlasSize = 256

function createTextureAtlas()
	--TODO MADE INRAM ATLAS instead of using the png Atlas.png or probably i will not remove the Atlas.png creation(for debug) and making its creation into an another thread, but will use the INRAM ATLAS
	local totalTimeStart = os.clock()
	if finalAtlasSize < 256 or finalAtlasSize % 256 ~= 0 then
		error("finalAtlasSize must be a multiple of 256 and not less than 256")
	end
	local function initializeAtlas(atlasSize)
		local atlas = loveimage.newImageData(atlasSize, atlasSize)
		local x, y = 0, 0
		textureAtlassCoordinates = {}

		local needResize = false
		repeat
			local loopStartTime = os.clock()

			for blockType, texturePaths in pairs(TilesTextureAtlasList) do
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
							textureAtlassCoordinates = {}
							needResize = true
							break
						else
							needResize = false
						end

						atlas:paste(imageData, x, y)

						local tileWidth, tileHeight = 16, 16
						local index = x / tileWidth + y / tileHeight * (finalAtlasSize / tileHeight)

						textureAtlassCoordinates[blockType] = { index }

						x = x + width
					else
						print("Failed to read file:", texturePath)
					end
				end

				if needResize then
					break
				end
			end

			local loopEndTime = os.clock()
			local loopElapsedTime = loopEndTime - loopStartTime
			print("Atlas Time taken in loop: " .. loopElapsedTime .. " seconds")
		until not needResize

		local totalTimeEnd = os.clock()
		local totalTimeElapsed = totalTimeEnd - totalTimeStart
		print("Atlas Total time taken: " .. totalTimeElapsed .. " seconds")

		return atlas
	end

	local atlasSize = finalAtlasSize

	local atlas = initializeAtlas(atlasSize)

	local atlasDirectory = "Atlass"
	lovefilesystem.createDirectory(atlasDirectory)

	local saveStartTime = os.clock()
	local atlasImagePath = atlasDirectory .. "/Atlas.png"
	local pngData = atlas:encode("png")
	lovefilesystem.write(atlasImagePath, pngData)
	local saveEndTime = os.clock()

	local saveElapsedTime = saveEndTime - saveStartTime
	print("Atlas Time taken for saving: " .. saveElapsedTime .. " seconds")

	print("Created Atlas.png at " .. lovefilesystem.getSaveDirectory() .. "/Atlass , with size " .. atlasSize)

	return atlas, TilesTextureList
end
