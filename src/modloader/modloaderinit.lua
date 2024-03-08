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

function LoadMods()
	-- ModsRequireIteration
	-- Specify the path to the mods directory
	local modsDirectory = "mods/"

	-- Print debugging information
	print("Checking mods directory:", modsDirectory)

	-- Iterate over all items in the mods directory
	local items = lovefilesystem.getDirectoryItems(modsDirectory)
	for _, item in ipairs(items) do
		local fullPath = modsDirectory .. item

		if lovefilesystem.getInfo(fullPath, "directory") then
			local modName = item
			print("Attempting to load mod:", modName)

			-- Get the start time
			local startTime = os.clock()

			-- Load the mod
			local success, mod = pcall(require, "mods." .. modName .. "." .. modName)

			-- Check if the mod loaded successfully
			if success then
				print("Mod loaded successfully:", modName)
				-- Assuming the mod has an initialization function
				if mod.initialize then
					mod.initialize()
				end

				-- Get the end time after initialization
				local endTime = os.clock()

				-- Calculate the load time
				local loadTime = endTime - startTime

				-- Print the load time
				print("Load time for", modName, ":", loadTime, "seconds")
			else
				print("Failed to load mod:", modName)
				print("Error:", mod)
			end
		end
	end
end

function LoadBlocksAndTiles(directory)
	-- Imprimez des informations de débogage
	print("Vérification du répertoire des blocs :", directory)

	-- Parcourez tous les éléments dans le répertoire
	local items = love.filesystem.getDirectoryItems(directory)
	for _, item in ipairs(items) do
		local fullPath = directory .. "/" .. item

		-- Vérifiez si l'élément est un répertoire
		if love.filesystem.getInfo(fullPath).type == "directory" then
			-- Si c'est un répertoire, appelez la fonction récursivement
			LoadBlocksAndTiles(fullPath)
		elseif item:match("%.lua$") and item ~= "tiledata.lua" then -- Vérifiez si l'élément est un script Lua
			local blockName = item:sub(1, -5) -- Nom du bloc (nom du fichier sans l'extension .lua)
			print("Tentative de chargement du bloc :", blockName)

			-- Obtenez l'heure de début
			local startTime = os.clock()

			-- Chargez le bloc
			local success, block = pcall(require, directory:gsub("/", ".") .. "." .. blockName)

			-- Vérifiez si le bloc a été chargé avec succès
			if success then
				print("Bloc chargé avec succès :", blockName)
				if block and type(block) == "table" and block.initialize then
					block.initialize()
				end
				-- Obtenez l'heure de fin après l'initialisation
				local endTime = os.clock()

				-- Calculez le temps de chargement
				local loadTime = endTime - startTime

				-- Imprimez le temps de chargement
				print("Temps de chargement pour", blockName, ":", loadTime, "secondes")
			else
				print("Échec du chargement du bloc :", blockName)
				print("Erreur :", block)
			end
		end
	end
end
