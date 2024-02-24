function LoadMods()
	_JPROFILER.push("LoadMods")
	-- ModsRequireIteration
	-- Specify the path to the mods directory
	local modsDirectory = "mods/"

	-- Print debugging information
	LuaCraftPrint("Checking mods directory:", modsDirectory)

	-- Iterate over all items in the mods directory
	local items = love.filesystem.getDirectoryItems(modsDirectory)
	for _, item in ipairs(items) do
		local fullPath = modsDirectory .. item

		-- Print debugging information
		LuaCraftPrint("Checking item:", fullPath)

		-- Check if the item is a directory
		if love.filesystem.getInfo(fullPath, "directory") then
			-- Assuming you want to load mods from subdirectories
			local modName = item
			LuaCraftPrint("Attempting to load mod:", modName)

			-- Load the mod
			local success, mod = pcall(require, "mods." .. modName .. "." .. modName)

			-- Check if the mod loaded successfully
			if success then
				LuaCraftPrint("Mod loaded successfully:", modName)
				-- Assuming the mod has an initialization function
				if mod.initialize then
					mod.initialize()
				end
			else
				LuaCraftPrint("Failed to load mod:", modName)
				LuaCraftPrint("Error:", mod)
			end
		end
	end
	_JPROFILER.pop("LoadMods")
end

function ModLoaderInitALL()
	_JPROFILER.push("ModLoaderInitALL")
	--InitStructureConfigurationOLD()
	InitStructureConfigurationNEW()
	_JPROFILER.pop("ModLoaderInitALL")
end

--function InitStructureConfigurationOLD()
--	_JPROFILER.push("InitStructureConfigurationOLD")
--	Config:setRandomLocationStructureGenerator(generatePillarAtRandomLocation)
--	Config:setFixedPositionStructureGenerator(generatePillarAtFixedPosition)
--	_JPROFILER.pop("InitStructureConfigurationOLD")
--end

function InitStructureConfigurationNEW()
	_JPROFILER.push("InitStructureConfigurationtest")

	local generateStructuresatRandomLocation = getFunctionsByTag("generateStructuresatRandomLocation")
	for _, func in ipairs(generateStructuresatRandomLocation) do
		LuaCraftPrint("Random Location Generator found:", func)
		Config:setRandomLocationStructureGenerator(func)
	end

	local generateStructuresInPlayerRange = getFunctionsByTagWithXYZ("generateStructuresInPlayerRange")
	for _, entry in ipairs(generateStructuresInPlayerRange) do
		local func, params = entry.func, entry.params
		LuaCraftPrint("Fixed Position Generator found:")
		LuaCraftPrint("Function:", func)
		LuaCraftPrint("Parameters:")
		LuaCraftPrint("  x:", params.x)
		LuaCraftPrint("  y:", params.y)
		LuaCraftPrint("  z:", params.z)

		Config:setFixedPositionStructureGeneratorUsingPlayerRangeWithXYZ(func, params.x, params.y, params.z)
	end
	local generateStructuresatFixedPositions = getFunctionsByTagWithXYZ("generateStructuresatFixedPositions")
	for _, entry in ipairs(generateStructuresatFixedPositions) do
		local func, params = entry.func, entry.params
		LuaCraftPrint("Fixed Position Generator found:")
		LuaCraftPrint("Function:", func)
		LuaCraftPrint("Parameters:")
		LuaCraftPrint("  x:", params.x)
		LuaCraftPrint("  y:", params.y)
		LuaCraftPrint("  z:", params.z)

		Config:setFixedPositionStructureGeneratorUsingIsChunkFullyGeneratedWithXYZ(func, params.x, params.y, params.z)
	end

	_JPROFILER.pop("InitStructureConfigurationtest")
end
