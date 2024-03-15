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
local function createTextureAtlas(memoryorpng)
	assert(
		finalAtlasSize >= 256 and finalAtlasSize % 256 == 0,
		"finalAtlasSize must be a multiple of 256 and not less than 256"
	)
	local totalTimeStart = os.clock()

	local atlasSize = finalAtlasSize
	local atlas = loveimage.newImageData(atlasSize, atlasSize)
	local x, y = 0, 0

	for _, blockType in ipairs(getKeysInOrder(TilesTextureFORAtlasList)) do
		local texturePaths = TilesTextureFORAtlasList[blockType] or { TilesTextureFORAtlasList[blockType] }

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
				local ids = BlockThatUseCustomTexturesForTopandSide[blockType]
				textureAtlasCoordinates[blockType] = ids and { index, index - 2, index - 1 } or { index }
				x = x + width
			else
				LuaCraftPrintLoggingNormal("Failed to read file:", texturePath)
			end
		end
	end

	local totalTimeElapsed = os.clock() - totalTimeStart
	LuaCraftPrintLoggingNormal(" Atlas Total time taken: " .. totalTimeElapsed .. " seconds")

	if memoryorpng == "PNG" then
		local atlasDirectory = "Atlas"
		lovefilesystem.createDirectory(atlasDirectory)
		local atlasImagePath = atlasDirectory .. "/Atlas" .. ".png"
		local pngData = atlas:encode("png")
		lovefilesystem.write(atlasImagePath, pngData)
	end

	return atlas, textureAtlasCoordinates
end
local function createTILEINGameAssets()
	createTextureAtlas("PNG")
	local atlasInRAM = createTextureAtlas("RAM")
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
function InitializeAssets()
	_JPROFILER.push("InitializeTilesNumberAndName")
	InitializeTilesNumberAndName()
	_JPROFILER.pop("InitializeTilesNumberAndName")
	_JPROFILER.push("InitalizeTextureStatic")
	InitalizeTextureStatic()
	_JPROFILER.pop("InitalizeTextureStatic")
	_JPROFILER.push("createTILEINGameAssets")
	createTILEINGameAssets()
	_JPROFILER.pop("createTILEINGameAssets")
	TilesTextureFORAtlasList = {}
end
