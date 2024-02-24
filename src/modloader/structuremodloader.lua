Config = {}

function Config:new()
	local obj = {}
	setmetatable(obj, self)
	self.__index = self
	return obj
end

function Config:setRandomLocationStructureGenerator(generatorFunc)
	self.randomLocationStructureGenerator = generatorFunc
end

function Config:getRandomLocationStructureGenerator()
	return self.randomLocationStructureGenerator or function() end
end

function Config:setFixedPositionStructureGeneratorInPlayerRenderDistanceTechnical(generatorFunc)
	self.fixedPositionStructureGeneratorInPlayerRenderDistanceTechnical = generatorFunc
end

function Config:getFixedPositionStructureGeneratorInPlayerRenderDistanceTechnical()
	return self.fixedPositionStructureGeneratorInPlayerRenderDistanceTechnical or function() end
end

function Config:setFixedPositionStructureGeneratorisChunkFullyGeneratedTechnical(generatorFunc)
	self.fixedPositionStructureGeneratorisChunkFullyGeneratedTechnical = generatorFunc
end

function Config:getFixedPositionStructureGeneratorIsChunkFullyGeneratedTechnical()
	return self.fixedPositionStructureGeneratorisChunkFullyGeneratedTechnical or function() end
end
