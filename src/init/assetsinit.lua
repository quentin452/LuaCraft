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
		FinalAtlasSize >= 256 and FinalAtlasSize % 256 == 0,
		"FinalAtlasSize must be a multiple of 256 and not less than 256"
	)
	local totalTimeStart = os.clock()

	local atlasSize = FinalAtlasSize
	local atlas = Loveimage.newImageData(atlasSize, atlasSize)
	local x, y = 0, 0

	for _, blockType in ipairs(getKeysInOrder(TilesTextureFORAtlasList)) do
		local texturePaths = TilesTextureFORAtlasList[blockType] or { TilesTextureFORAtlasList[blockType] }

		for _, texturePath in ipairs(texturePaths) do
			local fileExist = Lovefilesystem.getInfo(texturePath)
			if fileExist then
				local fileData = Lovefilesystem.read(texturePath)
				local fileDataObject = Lovefilesystem.newFileData(fileData, texturePath)
				local imageData = Loveimage.newImageData(fileDataObject)
				local width, height = imageData:getDimensions()

				if x + width > atlasSize then
					x = 0
					y = y + height
				end
				if y + height > atlasSize then
					atlasSize = atlasSize + 256
					FinalAtlasSize = atlasSize
					local newAtlas = Loveimage.newImageData(atlasSize, atlasSize)
					newAtlas:paste(atlas, 0, 0)
					atlas = newAtlas
					x, y = 0, 0
				end

				atlas:paste(imageData, x, y)
				local index = x / 16 + y / 16 * (FinalAtlasSize / 16)
				local ids = BlockThatUseCustomTexturesForTopandSide[blockType]
				TextureAtlasCoordinates[blockType] = ids and { index, index - 2, index - 1 } or { index }
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
		Lovefilesystem.createDirectory(atlasDirectory)
		local atlasImagePath = atlasDirectory .. "/Atlas" .. ".png"
		local pngData = atlas:encode("png")
		Lovefilesystem.write(atlasImagePath, pngData)
	end

	return atlas, TextureAtlasCoordinates
end
local function createTILEINGameAssets()
	createTextureAtlas("PNG")
	local atlasInRAM = createTextureAtlas("RAM")
	atlasImage = Lovegraphics.newImage(atlasInRAM)
	TilesTextureList = {}
	for blockType, _ in pairs(TextureAtlasCoordinates) do
		if not TilesTextureList[blockType] then
			TilesTextureList[blockType] = { unpack(TextureAtlasCoordinates[blockType]) }
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
