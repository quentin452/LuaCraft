function addFunctionToTag(tag, func, sourcePath)
	if not sourcePath or sourcePath ~= debug.getinfo(2).source then
		error("Invalid sourcePath provided for addFunctionToTag." .. tag)
	end
	if not ModLoaderTable[tag] then
		ModLoaderTable[tag] = {}
	end
	table.insert(ModLoaderTable[tag], { func = func, sourcePath = sourcePath })
end
function GetSourcePath()
	return debug.getinfo(2).source
end
local nextId = 1
BlockThatUseCustomTexturesForTopandSide = {}
--TODO remove BlockThatUseCustomTexturesForTopandSide
local function loadImage(imageString)
	if imageString ~= nil and type(imageString) == "string" then
		return Lovegraphics.newImage(imageString)
	else
		return nil
	end
end
function addBlock(
	blockstringname,
	BlockOrLiquidOrTile,
	Cancollide,
	transparency,
	LightSources,
	blockBottomMasterTextureString,
	blockSideTextureString,
	blockTopTextureString
)
	if type(blockstringname) ~= "string" then
		ThreadLogChannel:push({
			LuaCraftLoggingLevel.ERROR,
			"blockstringname is not a string or is missing",
		})
		return
	end

	if type(LightSources) ~= "number" or LightSources < 0 or LightSources > 15 then
		ThreadLogChannel:push({
			LuaCraftLoggingLevel.ERROR,
			"Missing property or not in range property for LightSources in block "
				.. tostring(blockstringname)
				.. ". please ensure that 'LightSources' is within the range of 0 to 15",
		})
		return
	end
	local id = nextId
	Tiles[blockstringname] = {
		id = id,
		blockstringname = blockstringname,
		transparency = transparency,
		LightSources = LightSources,
		Cancollide = Cancollide,
		BlockOrLiquidOrTile = BlockOrLiquidOrTile,
		blockBottomMasterTextureString = blockBottomMasterTextureString,
		blockBottomMasterTextureUserData = loadImage(blockBottomMasterTextureString),
		blockSideTextureString = blockSideTextureString,
		blockSideTextureUserData = loadImage(blockSideTextureString),
		blockTopTextureString = blockTopTextureString,
		blockTopTextureUserData = loadImage(blockTopTextureString),
	}
	TilesById[id] = Tiles[blockstringname]
	if blockTopTextureString ~= nil or blockSideTextureString ~= nil then
		BlockThatUseCustomTexturesForTopandSide[id] = {
			top = loadImage(blockTopTextureString),
			side = loadImage(blockSideTextureString),
		}
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
					ThreadLogChannel:push({
						LuaCraftLoggingLevel.NORMAL,
						"Load time for" .. modName .. ": " .. loadTime .. " seconds",
					})
				else
					ThreadLogChannel:push({ LuaCraftLoggingLevel.ERROR, "Failed to load mod:", modName })
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
					ThreadLogChannel:push({ LuaCraftLoggingLevel.ERROR, "Failed to load block:", blockName })
				end
			end
		end
	end
end
