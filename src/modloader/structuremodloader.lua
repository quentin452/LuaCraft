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

function Config:setFixedPositionStructureGenerator(generatorFunc)
	self.fixedPositionStructureGenerator = generatorFunc
end

function Config:getFixedPositionStructureGenerator()
	return self.fixedPositionStructureGenerator or function() end
end
