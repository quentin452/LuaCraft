--TODO put lightning into another thread
local SIXDIRECTIONS = {
	{ x = 0, y = -1, z = 0 }, -- Down
	{ x = 0, y = 1, z = 0 }, -- Up
	{ x = 1, y = 0, z = 0 }, -- Right
	{ x = -1, y = 0, z = 0 }, -- Left
	{ x = 0, y = 0, z = 1 }, -- Forward
	{ x = 0, y = 0, z = -1 }, -- Backward
}
local FOURDIRECTIONS = {
	{ x = 1, y = 0, z = 0 }, -- Right
	{ x = -1, y = 0, z = 0 }, -- Left
	{ x = 0, y = 0, z = 1 }, -- Forward
	{ x = 0, y = 0, z = -1 }, -- Backward
}
local LightingQueue = {}

-- Function to add an item to the lighting queue
local function LightingQueueAdd(lthing)
	LightingQueue[#LightingQueue + 1] = lthing
	return lthing
end

function LightingUpdate()
	_JPROFILER.push("LightingUpdate")
	for _, lthing in ipairs(LightingQueue) do
		lthing:query()
	end
	LightingQueue = {}
	_JPROFILER.pop("LightingUpdate")
end

local function GetChunkFromCoordinates(x, y, z)
	local cget, cx, cy, cz = GetChunk(x, y, z)
	return cget, cx, cy, cz
end

-- Utilisez cette méthode dans vos fonctions
function NewSunlightAddition(x, y, z, value)
	local t = { x = x, y = y, z = z, value = value }
	t.query = function(self)
		local cget, cx, cy, cz = GetChunkFromCoordinates(self.x, self.y, self.z)
		if cget == nil then
			return
		end
		local val = cget:getVoxel(cx, cy, cz)
		local dat = cget:getVoxelFirstData(cx, cy, cz)
		if self.value >= 0 and TileSemiLightable(val) and dat < self.value then
			cget:setVoxelFirstData(cx, cy, cz, self.value)
			for _, dir in ipairs(SIXDIRECTIONS) do
				NewSunlightAddition(self.x + dir.x, self.y + dir.y, self.z + dir.z, self.value - 1)
			end
		end
	end
	LightingQueueAdd(t)
end

function NewSunlightAdditionCreation(x, y, z)
	local t = { x = x, y = y, z = z }
	t.query = function(self)
		local cget, cx, cy, cz = GetChunkFromCoordinates(self.x, self.y, self.z)
		if cget == nil then
			return
		end
		local val = cget:getVoxel(cx, cy, cz)
		local dat = cget:getVoxelFirstData(cx, cy, cz)
		if TileSemiLightable(val) and dat > 0 then
			NewSunlightForceAddition(self.x, self.y, self.z, dat)
		end
	end
	LightingQueueAdd(t)
end

function NewSunlightForceAddition(x, y, z, value)
	local t = { x = x, y = y, z = z, value = value }
	t.query = function(self)
		local cget, cx, cy, cz = GetChunkFromCoordinates(self.x, self.y, self.z)
		if cget == nil then
			return
		end
		local val = cget:getVoxel(cx, cy, cz)
		if self.value >= 0 and TileSemiLightable(val) then
			cget:setVoxelFirstData(cx, cy, cz, self.value)
			for _, dir in ipairs(SIXDIRECTIONS) do
				NewSunlightAddition(self.x + dir.x, self.y + dir.y, self.z + dir.z, self.value - 1)
			end
		end
	end
	LightingQueueAdd(t)
end

function NewSunlightDownAddition(x, y, z, value)
	local t = { x = x, y = y, z = z, value = value }
	t.query = function(self)
		local cget, cx, cy, cz = GetChunkFromCoordinates(self.x, self.y, self.z)
		if cget == nil then
			return
		end
		local val = cget:getVoxel(cx, cy, cz)
		local dat = cget:getVoxelFirstData(cx, cy, cz)
		if TileLightable(val) and dat <= self.value then
			cget:setVoxelFirstData(cx, cy, cz, self.value)
			NewSunlightDownAddition(self.x, self.y - 1, self.z, self.value)
			for _, dir in ipairs(FOURDIRECTIONS) do
				NewSunlightAddition(self.x + dir.x, self.y + dir.y, self.z + dir.z, self.value - 1)
			end
		end
	end
	LightingQueueAdd(t)
end

function NewSunlightSubtraction(x, y, z, value)
	local t = { x = x, y = y, z = z, value = value }
	t.query = function(self)
		local cget, cx, cy, cz = GetChunkFromCoordinates(self.x, self.y, self.z)
		if cget == nil then
			return
		end
		local val = cget:getVoxel(cx, cy, cz)
		local fget = cget:getVoxelFirstData(cx, cy, cz)
		if fget > 0 and self.value >= 0 and TileSemiLightable(val) then
			if fget < self.value then
				cget:setVoxelFirstData(cx, cy, cz, Tiles.AIR_Block.id)
				for _, dir in ipairs(SIXDIRECTIONS) do
					NewSunlightSubtraction(self.x + dir.x, self.y + dir.y, self.z + dir.z, fget)
				end
			else
				NewSunlightForceAddition(self.x, self.y, self.z, fget)
			end
			return false
		end
	end
	LightingQueueAdd(t)
end

function NewSunlightDownSubtraction(x, y, z)
	local t = { x = x, y = y, z = z }
	t.query = function(self)
		if TileSemiLightable(GetVoxel(self.x, self.y, self.z)) then
			SetVoxelFirstData(self.x, self.y, self.z, Tiles.AIR_Block.id)
			NewSunlightDownSubtraction(self.x, self.y - 1, self.z)
			for _, dir in ipairs(FOURDIRECTIONS) do
				NewSunlightSubtraction(self.x + dir.x, self.y + dir.y, self.z + dir.z, LightSources[15])
			end
			return true
		end
	end
	LightingQueueAdd(t)
end

function NewLocalLightAddition(x, y, z, value)
	local t = { x = x, y = y, z = z, value = value }
	t.query = function(self) --, x,y,z, value, chunk)
		local chunk = GetChunkFromCoordinates(self.x, self.y, self.z)
		if chunk == nil then
			return
		end
		local cx, cy, cz = Localize(self.x, self.y, self.z)
		local val, dis, dat = chunk:getVoxel(cx, cy, cz)
		if TileSemiLightable(val) and dat < self.value then
			chunk:setVoxelSecondData(cx, cy, cz, self.value)
			if self.value > 1 then
				for _, dir in ipairs(SIXDIRECTIONS) do
					NewLocalLightAddition(self.x + dir.x, self.y + dir.y, self.z + dir.z, self.value - 1)
				end
			end
		end
	end
	LightingQueueAdd(t)
end

function NewLocalLightSubtraction(x, y, z, value)
	local t = { x = x, y = y, z = z, value = value }
	t.query = function(self)
		local cget, cx, cy, cz = GetChunkFromCoordinates(self.x, self.y, self.z)
		if cget == nil then
			return
		end
		local val, dat = cget:getVoxel(cx, cy, cz)
		local fget = cget:getVoxelSecondData(cx, cy, cz)
		if fget > 0 and self.value >= 0 and TileSemiLightable(val) then
			if fget < self.value then
				cget:setVoxelSecondData(cx, cy, cz, 0)
				for _, dir in ipairs(SIXDIRECTIONS) do
					NewLocalLightSubtraction(self.x + dir.x, self.y + dir.y, self.z + dir.z, fget)
				end
			else
				NewLocalLightForceAddition(self.x, self.y, self.z, fget)
			end
			return false
		end
	end
	LightingQueueAdd(t)
end

function NewLocalLightForceAddition(x, y, z, value)
	local t = { x = x, y = y, z = z, value = value }
	t.query = function(self)
		local cget, cx, cy, cz = GetChunkFromCoordinates(self.x, self.y, self.z)
		if cget == nil then
			return
		end
		local val, dis, dat = cget:getVoxel(cx, cy, cz)
		if self.value >= 0 and TileSemiLightable(val) then
			cget:setVoxelSecondData(cx, cy, cz, self.value)
			for _, dir in ipairs(SIXDIRECTIONS) do
				NewLocalLightAddition(self.x + dir.x, self.y + dir.y, self.z + dir.z, self.value - 1)
			end
		end
	end
	LightingQueueAdd(t)
end

function NewLocalLightAdditionCreation(x, y, z)
	local t = { x = x, y = y, z = z }
	t.query = function(self)
		local cget, cx, cy, cz = GetChunkFromCoordinates(self.x, self.y, self.z)
		if cget == nil then
			return
		end
		local val, dis, dat = cget:getVoxel(cx, cy, cz)
		if TileSemiLightable(val) and dat > 0 then
			NewLocalLightForceAddition(self.x, self.y, self.z, dat)
		end
	end
	LightingQueueAdd(t)
end
