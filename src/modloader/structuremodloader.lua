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
function Config:setFixedPositionStructureGeneratorUsingPlayerRangeWithXYZ(generatorFunc, x, y, z)
	self.fixedPositionStructureGeneratorUsingPlayerRangeWithXYZ = { func = generatorFunc, x = x, y = y, z = z }
end
function Config:getFixedPositionStructureGeneratorUsingPlayerRangeWithXYZ()
	local storedInfo = self.fixedPositionStructureGeneratorUsingPlayerRangeWithXYZ

	return storedInfo.func, storedInfo.x, storedInfo.y, storedInfo.z
end

function Config:setFixedPositionStructureGeneratorUsingIsChunkFullyGeneratedWithXYZ(generatorFunc, x, y, z)
	self.fixedPositionStructureGeneratorisChunkFullyGeneratedTechnicalWithXYZ =
		{ func = generatorFunc, x = x, y = y, z = z }
end
function Config:getFixedPositionStructureGeneratorUsingIsChunkFullyGeneratedWithXYZ()
	local storedInfo = self.fixedPositionStructureGeneratorisChunkFullyGeneratedTechnicalWithXYZ

	return storedInfo.func, storedInfo.x, storedInfo.y, storedInfo.z
end
