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

local function LightningQueries(self, lightoperation)
	local cget, cx, cy, cz = GetChunk(self.x, self.y, self.z)
	if cget == nil then
		return function() end
	end

	if lightoperation == "NewSunlightForceAddition" then
		return function()
			local NewSunlightForceAdditionval = cget:getVoxel(cx, cy, cz)
			if self.value >= 0 and TileLightable(NewSunlightForceAdditionval, true) then
				cget:setVoxelFirstData(cx, cy, cz, self.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = self.x + dir.x
					NewLightOperation(x, self.y + dir.y, self.z + dir.z, "NewSunlightAddition", self.value - 1)
				end
			end
		end
	elseif lightoperation == "NewSunlightAdditionCreation" then
		return function()
			local valNewSunlightAdditionCreation = cget:getVoxel(cx, cy, cz)
			local datNewSunlightAdditionCreation = cget:getVoxelFirstData(cx, cy, cz)
			if TileLightable(valNewSunlightAdditionCreation, true) and datNewSunlightAdditionCreation > 0 then
				NewLightOperation(self.x, self.y, self.z, "NewSunlightForceAddition", datNewSunlightAdditionCreation)
			end
		end
	elseif lightoperation == "NewSunlightDownAddition" then
		return function()
			local valNewSunlightDownAddition = cget:getVoxel(cx, cy, cz)
			local datNewSunlightDownAddition = cget:getVoxelFirstData(cx, cy, cz)
			if TileLightable(valNewSunlightDownAddition) and datNewSunlightDownAddition <= self.value then
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
			local valNewLocalLightForceAddition, _, _ = cget:getVoxel(cx, cy, cz)
			if self.value >= 0 and TileLightable(valNewLocalLightForceAddition, true) then
				cget:setVoxelSecondData(cx, cy, cz, self.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = self.x + dir.x
					NewLightOperation(x, self.y + dir.y, self.z + dir.z, "NewLocalLightAddition", self.value - 1)
				end
			end
		end
	elseif lightoperation == "NewLocalLightSubtraction" then
		return function()
			local valNewLocalLightSub, _ = cget:getVoxel(cx, cy, cz)
			local fgetNewLocalLightSub = cget:getVoxelSecondData(cx, cy, cz)
			if fgetNewLocalLightSub > 0 and self.value >= 0 and TileLightable(valNewLocalLightSub, true) then
				if fgetNewLocalLightSub < self.value then
					cget:setVoxelSecondData(cx, cy, cz, 0)
					for _, dir in ipairs(SIXDIRECTIONS) do
						local nx, ny, nz = self.x + dir.x, self.y + dir.y, self.z + dir.z
						NewLightOperation(nx, ny, nz, "NewLocalLightSubtraction", fgetNewLocalLightSub)
					end
				else
					NewLightOperation(self.x, self.y, self.z, "NewLocalLightForceAddition", fgetNewLocalLightSub)
				end
				return false
			end
		end
	elseif lightoperation == "NewLocalLightAdditionCreation" then
		return function()
			local valNewLocalLightAdditionCrea, _, datNewLocalLightAdditionCrea = cget:getVoxel(cx, cy, cz)
			if TileLightable(valNewLocalLightAdditionCrea, true) and valNewLocalLightAdditionCrea > 0 then
				NewLightOperation(self.x, self.y, self.z, "NewLocalLightForceAddition", datNewLocalLightAdditionCrea)
			end
		end
	elseif lightoperation == "NewSunlightAddition" then
		return function()
			local valNewSunlightAdd = cget:getVoxel(cx, cy, cz)
			local datNewSunlightAdd = cget:getVoxelFirstData(cx, cy, cz)
			if self.value >= 0 and TileLightable(valNewSunlightAdd, true) and datNewSunlightAdd < self.value then
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
			local valNewLocalLightAddition, _, datNewLocalLightAddition = cget:getVoxel(localcx, localcy, localcz)
			if TileLightable(valNewLocalLightAddition, true) and datNewLocalLightAddition < self.value then
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
			local valNewSunlightSub = cget:getVoxel(cx, cy, cz)
			local fgetSunlightSub = cget:getVoxelFirstData(cx, cy, cz)
			if fgetSunlightSub > 0 and self.value >= 0 and TileLightable(valNewSunlightSub, true) then
				if fgetSunlightSub < self.value then
					cget:setVoxelFirstData(cx, cy, cz, Tiles.AIR_Block.id)
					for _, dir in ipairs(SIXDIRECTIONS) do
						local x = self.x + dir.x
						NewLightOperation(x, self.y + dir.y, self.z + dir.z, "NewSunlightSubtraction", fgetSunlightSub)
					end
				else
					NewLightOperation(self.x, self.y, self.z, "NewSunlightForceAddition", fgetSunlightSub)
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
