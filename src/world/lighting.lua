--TODO put lightning into another thread
local SIXDIRECTIONS = {
	{ x = 0, y = -1, z = 0 }, -- Down
	{ x = 0, y = 1, z = 0 }, -- Up
	{ x = 1, y = 0, z = 0 }, -- Right
	{ x = -1, y = 0, z = 0 }, -- Left
	{ x = 0, y = 0, z = 1 }, -- Forward
	{ x = 0, y = 0, z = -1 }, -- Backward
}

local LightingQueue = {}
local LightingRemovalQueue = {}

-- Function to add an item to the lighting queue
local function LightingQueueAdd(lthing)
	LightingQueue[#LightingQueue + 1] = lthing
	return lthing
end

-- Function to add an item to the lighting removal queue
local function LightingRemovalQueueAdd(lthing)
	LightingRemovalQueue[#LightingRemovalQueue + 1] = lthing
	return lthing
end

function LightingUpdate()
	for _, lthing in ipairs(LightingRemovalQueue) do
		lthing:query()
	end
	for _, lthing in ipairs(LightingQueue) do
		lthing:query()
	end
	LightingRemovalQueue = {}
	LightingQueue = {}
end

local function NewSunlightForceAddition(x, y, z, value)
	local t = { x = x, y = y, z = z, value = value, querytype = "NewSunlightForceAddition" }
	t.query = LightningQueries(t)
	LightingQueueAdd(t)
end
local function NewSunlightAdditionCreation(x, y, z)
	local t = { x = x, y = y, z = z, querytype = "NewSunlightAdditionCreation" }
	t.query = LightningQueries(t)
	LightingQueueAdd(t)
end

local function NewSunlightDownAddition(x, y, z, value)
	local t = { x = x, y = y, z = z, value = value, querytype = "NewSunlightDownAddition" }
	t.query = LightningQueries(t)
	LightingQueueAdd(t)
end

local function NewLocalLightForceAddition(x, y, z, value)
	local t = { x = x, y = y, z = z, value = value, querytype = "NewLocalLightForceAddition" }
	t.query = LightningQueries(t)
	LightingQueueAdd(t)
end

local function NewLocalLightSubtraction(x, y, z, value)
	local t = { x = x, y = y, z = z, value = value, querytype = "NewLocalLightSubtraction" }
	t.query = LightningQueries(t)
	LightingRemovalQueueAdd(t)
end
local function NewLocalLightAdditionCreation(x, y, z)
	local t = { x = x, y = y, z = z, querytype = "NewLocalLightAdditionCreation" }
	t.query = LightningQueries(t)
	LightingQueueAdd(t)
end
local function NewSunlightAddition(x, y, z, value)
	local t = { x = x, y = y, z = z, value = value, querytype = "NewSunlightAddition" }
	t.query = LightningQueries(t)
	LightingQueueAdd(t)
end

local function NewLocalLightAddition(x, y, z, value)
	local t = { x = x, y = y, z = z, value = value, querytype = "NewLocalLightAddition" }
	t.query = LightningQueries(t)
	LightingQueueAdd(t)
end
local function NewSunlightSubtraction(x, y, z, value)
	local t = { x = x, y = y, z = z, value = value, querytype = "NewSunlightSubtraction" }
	t.query = LightningQueries(t)
	LightingRemovalQueueAdd(t)
end
local function NewSunlightDownSubtraction(x, y, z)
	local t = { x = x, y = y, z = z, querytype = "NewSunlightDownSubtraction" }
	t.query = LightningQueries(t)
	LightingRemovalQueueAdd(t)
end

function LightningQueries(self)
	local cget, cx, cy, cz = GetChunk(self.x, self.y, self.z)
	if cget == nil then
		return function() end
	end

	if self.querytype == "NewSunlightForceAddition" then
		return function()
			local val = cget:getVoxel(cx, cy, cz)
			if self.value >= 0 and TileLightable(val, true) then
				cget:setVoxelFirstData(cx, cy, cz, self.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					NewSunlightAddition(self.x + dir.x, self.y + dir.y, self.z + dir.z, self.value - 1)
				end
			end
		end
	elseif self.querytype == "NewSunlightAdditionCreation" then
		return function()
			local val = cget:getVoxel(cx, cy, cz)
			local dat = cget:getVoxelFirstData(cx, cy, cz)
			if TileLightable(val, true) and dat > 0 then
				NewSunlightForceAddition(self.x, self.y, self.z, dat)
			end
		end
	elseif self.querytype == "NewSunlightDownAddition" then
		return function()
			local val = cget:getVoxel(cx, cy, cz)
			local dat = cget:getVoxelFirstData(cx, cy, cz)
			if TileLightable(val) and dat <= self.value then
				cget:setVoxelFirstData(cx, cy, cz, self.value)
				NewSunlightDownAddition(self.x, self.y - 1, self.z, self.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					NewSunlightAddition(self.x + dir.x, self.y + dir.y, self.z + dir.z, self.value - 1)
				end
			end
		end
	elseif self.querytype == "NewLocalLightForceAddition" then
		return function()
			local val, dis, dat = cget:getVoxel(cx, cy, cz)
			if self.value >= 0 and TileLightable(val, true) then
				cget:setVoxelSecondData(cx, cy, cz, self.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					NewLocalLightAddition(self.x + dir.x, self.y + dir.y, self.z + dir.z, self.value - 1)
				end
			end
		end
	elseif self.querytype == "NewLocalLightSubtraction" then
		return function()
			local val, dat = cget:getVoxel(cx, cy, cz)
			local fget = cget:getVoxelSecondData(cx, cy, cz)
			if fget > 0 and self.value >= 0 and TileLightable(val, true) then
				if fget < self.value then
					cget:setVoxelSecondData(cx, cy, cz, 0)
					for _, dir in ipairs(SIXDIRECTIONS) do
						local nx, ny, nz = self.x + dir.x, self.y + dir.y, self.z + dir.z
						NewLocalLightSubtraction(nx, ny, nz, fget)
					end
				else
					NewLocalLightForceAddition(self.x, self.y, self.z, fget)
				end
				return false
			end
		end
	elseif self.querytype == "NewLocalLightAdditionCreation" then
		return function()
			local val, dis, dat = cget:getVoxel(cx, cy, cz)
			if TileLightable(val, true) and dat > 0 then
				NewLocalLightForceAddition(self.x, self.y, self.z, dat)
			end
		end
	elseif self.querytype == "NewSunlightAddition" then
		return function()
			local val = cget:getVoxel(cx, cy, cz)
			local dat = cget:getVoxelFirstData(cx, cy, cz)
			if self.value >= 0 and TileLightable(val, true) and dat < self.value then
				cget:setVoxelFirstData(cx, cy, cz, self.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					NewSunlightAddition(self.x + dir.x, self.y + dir.y, self.z + dir.z, self.value - 1)
				end
			end
		end
	elseif self.querytype == "NewLocalLightAddition" then
		return function()
			local localcx, localcy, localcz = Localize(self.x, self.y, self.z)
			local val, dis, dat = cget:getVoxel(localcx, localcy, localcz)
			if TileLightable(val, true) and dat < self.value then
				cget:setVoxelSecondData(localcx, localcy, localcz, self.value)
				if self.value > 1 then
					for _, dir in ipairs(SIXDIRECTIONS) do
						NewLocalLightAddition(self.x + dir.x, self.y + dir.y, self.z + dir.z, self.value - 1)
					end
				end
			end
		end
	elseif self.querytype == "NewSunlightSubtraction" then
		return function()
			local val = cget:getVoxel(cx, cy, cz)
			local fget = cget:getVoxelFirstData(cx, cy, cz)
			if fget > 0 and self.value >= 0 and TileLightable(val, true) then
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
	elseif self.querytype == "NewSunlightDownSubtraction" then
		return function()
			if TileLightable(GetVoxel(self.x, self.y, self.z), true) then
				SetVoxelFirstData(self.x, self.y, self.z, Tiles.AIR_Block.id)
				NewSunlightDownSubtraction(self.x, self.y - 1, self.z)
				for _, dir in ipairs(SIXDIRECTIONS) do
					NewSunlightSubtraction(self.x + dir.x, self.y + dir.y, self.z + dir.z, LightSources[15])
				end
				return true
			end
		end
	end
end
local operationFunctions = {
	["NewSunlightAddition"] = NewSunlightAddition,
	["NewSunlightAdditionCreation"] = NewSunlightAdditionCreation,
	["NewSunlightForceAddition"] = NewSunlightForceAddition,
	["NewSunlightDownAddition"] = NewSunlightDownAddition,
	["NewSunlightSubtraction"] = NewSunlightSubtraction,
	["NewSunlightDownSubtraction"] = NewSunlightDownSubtraction,
	["NewLocalLightSubtraction"] = NewLocalLightSubtraction,
	["NewLocalLightForceAddition"] = NewLocalLightForceAddition,
	["NewLocalLightAddition"] = NewLocalLightAddition,
	["NewLocalLightAdditionCreation"] = NewLocalLightAdditionCreation,
}

function LightOperation(x, y, z, operation, value)
	local operationFunction = operationFunctions[operation]
	if operationFunction then
		operationFunction(x, y, z, value)
	else
		LuaCraftErrorLogging("using wrong operation for LightOperation")
	end
end
