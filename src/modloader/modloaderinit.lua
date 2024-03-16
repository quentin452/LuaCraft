function addFunctionToTag(tag, func)
	if not ModLoaderTable[tag] then
		ModLoaderTable[tag] = {}
	end
	table.insert(ModLoaderTable[tag], func)
end
local nextId = 1
TilesById = { [0] = {
	blockstringname = "AIR_Block",
} }
BlockThatUseCustomTexturesForTopandSide = {}
function addBlock(
	blockstringname,
	BlockOrLiquidOrTile,
	Cancollide,
	transparency,
	LightSources,
	blockBottomMasterTexture,
	blockSideTexture,
	blockTopTexture
)
	if Tiles[blockstringname] then
		LuaCraftErrorLogging("Error: Duplicate blockstringname detected: " .. tostring(blockstringname))
		return
	end

	local properties =
		{ "transparency", "LightSources", "Cancollide", "BlockOrLiquidOrTile", "blockBottomMasterTexture" }
	local block = {
		BlockOrLiquidOrTile = BlockOrLiquidOrTile,
		Cancollide = Cancollide,
		transparency = transparency,
		LightSources = LightSources,
		blockBottomMasterTexture = blockBottomMasterTexture,
	}

	if blockSideTexture ~= nil then
		block.blockSideTexture = blockSideTexture
	end

	if blockTopTexture ~= nil then
		block.blockTopTexture = blockTopTexture
	end

	local seen = {}

	for _, prop in ipairs(properties) do
		if block[prop] ~= nil then
			if seen[prop] then
				LuaCraftErrorLogging(
					"Error: Property " .. prop .. " is defined more than once in block " .. tostring(blockstringname)
				)
			else
				seen[prop] = true
			end
		else
			if prop == "LightSources" then
				LuaCraftErrorLogging(
					"Error: Missing property or not in range property for "
						.. prop
						.. " in block "
						.. tostring(blockstringname)
						.. ". please ensure that 'LightSources' is within the range of 0 to 15"
				)
			else
				LuaCraftErrorLogging("Error: Missing property " .. prop .. " in block " .. tostring(blockstringname))
			end
		end
	end
	seen = {}
	local id = nextId
	Tiles[blockstringname] = {
		id = id,
		blockstringname = blockstringname,
		transparency = transparency,
		LightSources = LightSources,
		Cancollide = Cancollide,
		BlockOrLiquidOrTile = BlockOrLiquidOrTile,
		blockBottomMasterTexture = blockBottomMasterTexture,
		blockSideTexture = blockSideTexture,
		blockTopTexture = blockTopTexture,
	}

	TilesById[id] = Tiles[blockstringname]
	if blockTopTexture ~= nil or blockSideTexture ~= nil then
		if type(blockTopTexture) == "string" then
			blockTopTexture = Lovegraphics.newImage(blockTopTexture)
		end
		if type(blockSideTexture) == "string" then
			blockSideTexture = Lovegraphics.newImage(blockSideTexture)
		end

		if BlockThatUseCustomTexturesForTopandSide[id] then
			LuaCraftErrorLogging(
				"Key already exists in BlockThatUseCustomTexturesForTopandSide: " .. block.blockstringname
			)
			return
		end

		BlockThatUseCustomTexturesForTopandSide[id] = { top = blockTopTexture, side = blockSideTexture }
	end
	nextId = nextId + 1
	return id
end

function LoadMods()
	local modsDirectory = "mods/"
	local directories = { modsDirectory }
	while #directories > 0 do
		local currentDirectory = table.remove(directories)
		local items = Lovefilesystem.getDirectoryItems(currentDirectory)
		for _, item in ipairs(items) do
			local fullPath = currentDirectory .. item
			local info = Lovefilesystem.getInfo(fullPath, "directory")
			if info then
				local modName = item
				local startTime = os.clock()
				local success, mod = pcall(require, "mods." .. modName .. "." .. modName)
				if success then
					if mod.initialize then
						mod.initialize()
					end
					local endTime = os.clock()
					local loadTime = endTime - startTime
					LuaCraftPrintLoggingNormal("Load time for", modName, ":", loadTime, "seconds")
				else
					LuaCraftErrorLogging("Failed to load mod:", modName)
				end
				table.insert(directories, fullPath)
			end
		end
	end
end

function LoadBlocksAndTiles(rootDirectory)
	local directories = { rootDirectory }
	while #directories > 0 do
		local currentDirectory = table.remove(directories)
		local items = love.filesystem.getDirectoryItems(currentDirectory)
		for _, item in ipairs(items) do
			local fullPath = currentDirectory .. "/" .. item
			local info = love.filesystem.getInfo(fullPath)
			if info.type == "directory" then
				table.insert(directories, fullPath)
			elseif item:match("%.lua$") and item ~= "tiledata.lua" then
				local blockName = item:sub(1, -5)
				local success, block = pcall(require, currentDirectory:gsub("/", ".") .. "." .. blockName)
				if success then
					if block and type(block) == "table" and block.initialize then
						block.initialize()
					end
				else
					LuaCraftErrorLogging("Failed to load block:", blockName)
				end
			end
		end
	end
end
