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

	local randomLocationGenerators = getFunctionsByTag("generateStructuresatRandomLocation")
	for _, func in ipairs(randomLocationGenerators) do
		print("Random Location Generator found:", func)
		Config:setRandomLocationStructureGenerator(func)
	end

	local fixedPositionGenerators = getFunctionsByTag("generateStructuresInPlayerRange")
	for _, func in ipairs(fixedPositionGenerators) do
		print("Fixed Position Generator found:", func)
		Config:setFixedPositionStructureGeneratorInPlayerRenderDistanceTechnical(func)
	end

	local fixedPositionGenerators = getFunctionsByTag("generateStructuresatFixedPositions")
	for _, func in ipairs(fixedPositionGenerators) do
		print("Fixed Position Generator found:", func)
		Config:setFixedPositionStructureGeneratorisChunkFullyGeneratedTechnical(func)
	end

	_JPROFILER.pop("InitStructureConfigurationtest")
end
