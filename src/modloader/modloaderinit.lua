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
		print("Random Location Generator found:", func)
		Config:setRandomLocationStructureGenerator(func)
	end


	local generateStructuresInPlayerRange = getFunctionsByTagWithXYZ("generateStructuresInPlayerRange")
	for _, entry in ipairs(generateStructuresInPlayerRange) do
		local func, params = entry.func, entry.params
		print("Fixed Position Generator found:")
		print("Function:", func)
		print("Parameters:")
		print("  x:", params.x)
		print("  y:", params.y)
		print("  z:", params.z)

		Config:setFixedPositionStructureGeneratorUsingPlayerRangeWithXYZ(func, params.x, params.y, params.z)
	end
	local generateStructuresatFixedPositions = getFunctionsByTagWithXYZ("generateStructuresatFixedPositions")
	for _, entry in ipairs(generateStructuresatFixedPositions) do
		local func, params = entry.func, entry.params
		print("Fixed Position Generator found:")
		print("Function:", func)
		print("Parameters:")
		print("  x:", params.x)
		print("  y:", params.y)
		print("  z:", params.z)

		Config:setFixedPositionStructureGeneratorUsingIsChunkFullyGeneratedWithXYZ(func, params.x, params.y, params.z)
	end

	_JPROFILER.pop("InitStructureConfigurationtest")
end
