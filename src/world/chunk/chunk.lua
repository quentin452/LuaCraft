local size = 16
local ffi = require("ffi")

Chunk = Object:extend()
Chunk.size = size
function Chunk:new(x, y, z)
	_JPROFILER.push("Chunk:new")
	self.data = {}
	self.cx = x
	self.cy = y
	self.cz = z
	self.x = x * size
	self.y = y * size
	self.z = z * size
	self.unloaded = false
	self.hash = ("%d/%d/%d"):format(x, y, z)
	self.frames = 0
	self.inRemeshQueue = false

	self:generateChunkData()
	--generatePillarEveryChunks(scene, 1)
	_JPROFILER.pop("Chunk:new")
end

function Chunk:generateChunkData()
	_JPROFILER.push("generateChunkData")
	local data = love.data.newByteData(size * size * size * ffi.sizeof("uint8_t"))
	local datapointer = ffi.cast("uint8_t *", data:getFFIPointer())
	local f = 0.125

	for i = 0, size * size * size - 1 do
		local x, y, z = i % size + self.x, math.floor(i / size) % size + self.y, math.floor(i / (size * size)) + self.z
		datapointer[i] = love.math.noise(x * f, y * f, z * f) > (z + 32) / 64 and 1 or 0
	end

	self.data = data
	self.datapointer = datapointer
	_JPROFILER.pop("generateChunkData")
end

function Chunk:getBlock(x, y, z)
	_JPROFILER.push("Chunk:getBlock")
	if self.dead then
		return
	end

	if x >= 0 and y >= 0 and z >= 0 and x < size and y < size and z < size then
		local i = x + size * y + size * size * z
		local result = self.datapointer[i]
		_JPROFILER.pop("Chunk:getBlock")
		return result
	end

	local chunk = scene():getChunkFromWorld(self.x + x, self.y + y, self.z + z)
	if chunk then
		local result = chunk:getBlock(x % size, y % size, z % size)
		_JPROFILER.pop("Chunk:getBlock")
		return result
	end

	_JPROFILER.pop("Chunk:getBlock")
	return -1
end

function Chunk:setBlock(x, y, z, value)
	_JPROFILER.push("Chunk:setBlock")
	if self.dead then
		return
	end

	local size = self.size
	local i = x + size * y + size * size * z

	if x >= 0 and y >= 0 and z >= 0 and x < size and y < size and z < size then
		self.datapointer[i] = value
		_JPROFILER.pop("Chunk:setBlock")
		return
	end

	local chunkX = self.x + x
	local chunkY = self.y + y
	local chunkZ = self.z + z

	local chunk = scene():getChunkFromWorld(chunkX, chunkY, chunkZ)
	if chunk then
		chunk:setBlock(chunkX % size, chunkY % size, chunkZ % size, value)
		_JPROFILER.pop("Chunk:setBlock")
		return
	end

	_JPROFILER.pop("Chunk:setBlock")
end

function Chunk:draw()
	_JPROFILER.push("Chunk:draw")
	if self.unloaded then
		return
	end
	if self.model and not self.dead then
		self.model:draw()
	end
	_JPROFILER.pop("Chunk:draw")
end

function Chunk:destroy()
	_JPROFILER.push("Chunk:destroy")
	if self.model then
		self.model.mesh:release()
	end
	self.dead = true
	self.data:release()
	scene().chunkMap[self.hash] = nil
	_JPROFILER.pop("Chunk:destroy")
end
