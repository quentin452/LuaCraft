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

function LightningQueries(self, lightoperation)
	local cget, cx, cy, cz = GetChunk(self.x, self.y, self.z)
	if cget == nil then
		return function() end
	end

	if lightoperation == "NewSunlightForceAddition" then
		return function()
			local val = cget:getVoxel(cx, cy, cz)
			if self.value >= 0 and TileLightable(val, true) then
				cget:setVoxelFirstData(cx, cy, cz, self.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = self.x + dir.x
					NewLightOperation(x, self.y + dir.y, self.z + dir.z, "NewSunlightAddition", self.value - 1)
				end
			end
		end
	elseif lightoperation == "NewSunlightAdditionCreation" then
		return function()
			local val = cget:getVoxel(cx, cy, cz)
			local dat = cget:getVoxelFirstData(cx, cy, cz)
			if TileLightable(val, true) and dat > 0 then
				NewLightOperation(self.x, self.y, self.z, "NewSunlightForceAddition", dat)
			end
		end
	elseif lightoperation == "NewSunlightDownAddition" then
		return function()
			local val = cget:getVoxel(cx, cy, cz)
			local dat = cget:getVoxelFirstData(cx, cy, cz)
			if TileLightable(val) and dat <= self.value then
				cget:setVoxelFirstData(cx, cy, cz, self.value)
				NewLightOperation(self.x, self.y - 1, self.z, "NewSunlightDownAddition", self.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = self.x + dir.x
					NewLightOperation(x, self.y + dir.y, self.z + dir.z, "NewSunlightAddition", self.value - 1)
				end
			end
		end
	elseif lightoperation == "NewLocalLightForceAddition" then
		return function()
			local val, _, _ = cget:getVoxel(cx, cy, cz)
			if self.value >= 0 and TileLightable(val, true) then
				cget:setVoxelSecondData(cx, cy, cz, self.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = self.x + dir.x
					NewLightOperation(x, self.y + dir.y, self.z + dir.z, "NewLocalLightAddition", self.value - 1)
				end
			end
		end
	elseif lightoperation == "NewLocalLightSubtraction" then
		return function()
			local val, _ = cget:getVoxel(cx, cy, cz)
			local fget = cget:getVoxelSecondData(cx, cy, cz)
			if fget > 0 and self.value >= 0 and TileLightable(val, true) then
				if fget < self.value then
					cget:setVoxelSecondData(cx, cy, cz, 0)
					for _, dir in ipairs(SIXDIRECTIONS) do
						local nx, ny, nz = self.x + dir.x, self.y + dir.y, self.z + dir.z
						NewLightOperation(nx, ny, nz, "NewLocalLightSubtraction", fget)
					end
				else
					NewLightOperation(self.x, self.y, self.z, "NewLocalLightForceAddition", fget)
				end
				return false
			end
		end
	elseif lightoperation == "NewLocalLightAdditionCreation" then
		return function()
			local val, _, dat = cget:getVoxel(cx, cy, cz)
			if TileLightable(val, true) and dat > 0 then
				NewLightOperation(self.x, self.y, self.z, "NewLocalLightForceAddition", dat)
			end
		end
	elseif lightoperation == "NewSunlightAddition" then
		return function()
			local val = cget:getVoxel(cx, cy, cz)
			local dat = cget:getVoxelFirstData(cx, cy, cz)
			if self.value >= 0 and TileLightable(val, true) and dat < self.value then
				cget:setVoxelFirstData(cx, cy, cz, self.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = self.x + dir.x
					NewLightOperation(x, self.y + dir.y, self.z + dir.z, "NewSunlightAddition", self.value - 1)
				end
			end
		end
	elseif lightoperation == "NewLocalLightAddition" then
		return function()
			local localcx, localcy, localcz = Localize(self.x, self.y, self.z)
			local val, _, dat = cget:getVoxel(localcx, localcy, localcz)
			if TileLightable(val, true) and dat < self.value then
				cget:setVoxelSecondData(localcx, localcy, localcz, self.value)
				if self.value > 1 then
					for _, dir in ipairs(SIXDIRECTIONS) do
						local x = self.x + dir.x
						NewLightOperation(x, self.y + dir.y, self.z + dir.z, "NewLocalLightAddition", self.value - 1)
					end
				end
			end
		end
	elseif lightoperation == "NewSunlightSubtraction" then
		return function()
			local val = cget:getVoxel(cx, cy, cz)
			local fget = cget:getVoxelFirstData(cx, cy, cz)
			if fget > 0 and self.value >= 0 and TileLightable(val, true) then
				if fget < self.value then
					cget:setVoxelFirstData(cx, cy, cz, Tiles.AIR_Block.id)
					for _, dir in ipairs(SIXDIRECTIONS) do
						local x = self.x + dir.x
						NewLightOperation(x, self.y + dir.y, self.z + dir.z, "NewSunlightSubtraction", fget)
					end
				else
					NewLightOperation(self.x, self.y, self.z, "NewSunlightForceAddition", fget)
				end
				return false
			end
		end
	elseif lightoperation == "NewSunlightDownSubtraction" then
		return function()
			if TileLightable(GetVoxel(self.x, self.y, self.z), true) then
				SetVoxelFirstData(self.x, self.y, self.z, Tiles.AIR_Block.id)
				NewLightOperation(self.x, self.y - 1, self.z, "NewSunlightDownSubtraction")
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = self.x + dir.x
					NewLightOperation(x, self.y + dir.y, self.z + dir.z, "NewSunlightSubtraction", LightSources[15])
				end
				return true
			end
		end
	end
end
local operationFunctions = {
	["NewSunlightForceAddition"] = LightingQueueAdd,
	["NewSunlightAdditionCreation"] = LightingQueueAdd,
	["NewSunlightDownAddition"] = LightingQueueAdd,
	["NewLocalLightForceAddition"] = LightingQueueAdd,
	["NewLocalLightAdditionCreation"] = LightingQueueAdd,
	["NewSunlightAddition"] = LightingQueueAdd,
	["NewLocalLightAddition"] = LightingQueueAdd,
	["NewLocalLightSubtraction"] = LightingRemovalQueueAdd,
	["NewSunlightSubtraction"] = LightingRemovalQueueAdd,
	["NewSunlightDownSubtraction"] = LightingRemovalQueueAdd,
}

function NewLightOperation(x, y, z, lightoperation, value)
	local t = { x = x, y = y, z = z, value = value }
	t.query = LightningQueries(t, lightoperation)
	local operationFunction = operationFunctions[lightoperation]
	if operationFunction then
		operationFunction(t)
	else
		LuaCraftErrorLogging("This lightoperation: " .. lightoperation .. " is not correct")
	end
end