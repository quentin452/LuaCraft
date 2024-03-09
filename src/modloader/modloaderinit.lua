ModLoaderTable = {}
function addFunctionToTag(tag, func)
	if not ModLoaderTable[tag] then
		ModLoaderTable[tag] = {}
	end
	table.insert(ModLoaderTable[tag], func)
end
local nextId = 1

function addBlock(key, block)
	local id = nextId
	Tiles[key] = id
	Tiles[id] = block

	nextId = nextId + 1

	return id
end

function addTransparencyLookup(block, transparency)
	if transparencyLookup[block] ~= nil then
		error("Key already exists in transparencyLookup: " .. getTileName(block))
	end
	transparencyLookup[block] = transparency
end

function addLightSourceLookup(block, lightsourcing)
	if lightSourceLookup[block] ~= nil then
		error("Key already exists in lightSourceLookup: " .. getTileName(block))
	end
	lightSourceLookup[block] = lightsourcing
end

function addTileNonCollidable(block)
	if nonCollidableTiles[block] ~= nil then
		error("Key already exists in nonCollidableTiles: " .. getTileName(block))
	end
	nonCollidableTiles[block] = true
end
function madeTile2DRenderedOnHUD(block)
	if Tile2DHUDTable[block] ~= nil then
		error("Key already exists in Tile2DHUDTable: " .. getTileName(block))
	end
	Tile2DHUDTable[block] = true
end
function transform3DBlockToA2DTile(block)
	if TileModelTable[block] ~= nil then
		error("Key already exists in TileModelTable: " .. getTileName(block))
	end
	TileModelTable[block] = 1
end

function useCustomTextureFORHUDTile(block, textureTOP, textureSIDE)
	if HUDTilesTextureListPersonalizedLookup[block] ~= nil then
		error("Key already exists in HUDTilesTextureListPersonalizedLookup: " .. getTileName(block))

	end
	if textureTOP == nil or textureSIDE == nil then
		LuaCraftErrorLogging("Both textureTOP and textureSIDE must be provided")
	end
	HUDTilesTextureListPersonalizedLookup[block] = { top = textureTOP, side = textureSIDE }
end

function LoadMods()
	local modsDirectory = "mods/"

	local items = lovefilesystem.getDirectoryItems(modsDirectory)
	for _, item in ipairs(items) do
		local fullPath = modsDirectory .. item

		if lovefilesystem.getInfo(fullPath, "directory") then
			local modName = item
			local startTime = os.clock()

			local success, mod = pcall(require, "mods." .. modName .. "." .. modName)

			if success then
				if mod.initialize then
					mod.initialize()
				end

				local endTime = os.clock()

				local loadTime = endTime - startTime

				print("Load time for", modName, ":", loadTime, "seconds")
			else
				error("Failed to load mod:", modName)
			end
		end
	end
end

function LoadBlocksAndTiles(directory)
	local items = love.filesystem.getDirectoryItems(directory)
	for _, item in ipairs(items) do
		local fullPath = directory .. "/" .. item

		if love.filesystem.getInfo(fullPath).type == "directory" then
			LoadBlocksAndTiles(fullPath)
		elseif item:match("%.lua$") and item ~= "tiledata.lua" then
			local blockName = item:sub(1, -5)

			local startTime = os.clock()

			local success, block = pcall(require, directory:gsub("/", ".") .. "." .. blockName)

			if success then
				if block and type(block) == "table" and block.initialize then
					block.initialize()
				end
			else
				error("Failed to load block:", blockName)
			end
		end
	end
end
