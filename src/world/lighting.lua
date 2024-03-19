--TODO put lightning into another thread
local SIXDIRECTIONS = {
	{ x = 0, y = -1, z = 0 }, -- Down
	{ x = 0, y = 1, z = 0 }, -- Up
	{ x = 1, y = 0, z = 0 }, -- Right
	{ x = -1, y = 0, z = 0 }, -- Left
	{ x = 0, y = 0, z = 1 }, -- Forward
	{ x = 0, y = 0, z = -1 }, -- Backward
}

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
		local query = lthing.query
		query()
	end
	for _, lthing in ipairs(LightingQueue) do
		local query = lthing.query
		query()
	end
	LightingRemovalQueue = {}
	LightingQueue = {}
end

local function LightningQueries(lthing, lightoperation)
	local cget, cx, cy, cz = GetChunk(lthing.x, lthing.y, lthing.z)

	if cget == nil then
		lthing.query = function() end
		return lthing
	end

	if lightoperation == "NewSunlightForceAddition" then
		lthing.query = function()
			local val = cget:getVoxel(cx, cy, cz)
			if lthing.value >= 0 and TileLightable(val, true) then
				cget:setVoxelFirstData(cx, cy, cz, lthing.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = lthing.x + dir.x
					NewLightOperation(x, lthing.y + dir.y, lthing.z + dir.z, LightOpe.SunAdd, lthing.value - 1)
				end
			end
		end
	elseif lightoperation == "NewSunlightAdditionCreation" then
		lthing.query = function()
			local val = cget:getVoxel(cx, cy, cz)
			local dat = cget:getVoxelFirstData(cx, cy, cz)
			if TileLightable(val, true) and dat > 0 then
				NewLightOperation(lthing.x, lthing.y, lthing.z, LightOpe.SunForceAdd, dat)
			end
		end
	elseif lightoperation == "NewSunlightDownAddition" then
		lthing.query = function()
			local val = cget:getVoxel(cx, cy, cz)
			local dat = cget:getVoxelFirstData(cx, cy, cz)
			if TileLightable(val) and dat <= lthing.value then
				cget:setVoxelFirstData(cx, cy, cz, lthing.value)
				NewLightOperation(lthing.x, lthing.y - 1, lthing.z, LightOpe.SunDownAdd, lthing.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = lthing.x + dir.x
					NewLightOperation(x, lthing.y + dir.y, lthing.z + dir.z, LightOpe.SunAdd, lthing.value - 1)
				end
			end
		end
	elseif lightoperation == "NewLocalLightForceAddition" then
		lthing.query = function()
			local val, _, _ = cget:getVoxel(cx, cy, cz)
			if lthing.value >= 0 and TileLightable(val, true) then
				cget:setVoxelSecondData(cx, cy, cz, lthing.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = lthing.x + dir.x
					NewLightOperation(x, lthing.y + dir.y, lthing.z + dir.z, LightOpe.LocalAdd, lthing.value - 1)
				end
			end
		end
	elseif lightoperation == "NewLocalLightSubtraction" then
		lthing.query = function()
			local val, _ = cget:getVoxel(cx, cy, cz)
			local fget = cget:getVoxelSecondData(cx, cy, cz)
			if fget > 0 and lthing.value >= 0 and TileLightable(val, true) then
				if fget < lthing.value then
					cget:setVoxelSecondData(cx, cy, cz, 0)
					for _, dir in ipairs(SIXDIRECTIONS) do
						local nx, ny, nz = lthing.x + dir.x, lthing.y + dir.y, lthing.z + dir.z
						NewLightOperation(nx, ny, nz, LightOpe.LocalSubtract, fget)
					end
				else
					NewLightOperation(lthing.x, lthing.y, lthing.z, LightOpe.LocalForceAdd, fget)
				end
				return false
			end
		end
	elseif lightoperation == "NewLocalLightAdditionCreation" then
		lthing.query = function()
			local val, _, dat = cget:getVoxel(cx, cy, cz)
			if TileLightable(val, true) and dat > 0 then
				NewLightOperation(lthing.x, lthing.y, lthing.z, LightOpe.LocalForceAdd, dat)
			end
		end
	elseif lightoperation == "NewSunlightAddition" then
		lthing.query = function()
			local val = cget:getVoxel(cx, cy, cz)
			local dat = cget:getVoxelFirstData(cx, cy, cz)
			if lthing.value >= 0 and TileLightable(val, true) and dat < lthing.value then
				cget:setVoxelFirstData(cx, cy, cz, lthing.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = lthing.x + dir.x
					NewLightOperation(x, lthing.y + dir.y, lthing.z + dir.z, LightOpe.SunAdd, lthing.value - 1)
				end
			end
		end
	elseif lightoperation == "NewLocalLightAddition" then
		lthing.query = function()
			local localcx, localcy, localcz = Localize(lthing.x, lthing.y, lthing.z)
			local val, _, dat = cget:getVoxel(localcx, localcy, localcz)
			if TileLightable(val, true) and dat < lthing.value then
				cget:setVoxelSecondData(localcx, localcy, localcz, lthing.value)
				if lthing.value > 1 then
					for _, dir in ipairs(SIXDIRECTIONS) do
						local x = lthing.x + dir.x
						NewLightOperation(x, lthing.y + dir.y, lthing.z + dir.z, LightOpe.LocalAdd, lthing.value - 1)
					end
				end
			end
		end
	elseif lightoperation == "NewSunlightSubtraction" then
		lthing.query = function()
			local val = cget:getVoxel(cx, cy, cz)
			local fget = cget:getVoxelFirstData(cx, cy, cz)
			if fget > 0 and lthing.value >= 0 and TileLightable(val, true) then
				if fget < lthing.value then
					cget:setVoxelFirstData(cx, cy, cz, Tiles.AIR_Block.id)
					for _, dir in ipairs(SIXDIRECTIONS) do
						local x = lthing.x + dir.x
						NewLightOperation(x, lthing.y + dir.y, lthing.z + dir.z, LightOpe.SunSubtract, fget)
					end
				else
					NewLightOperation(lthing.x, lthing.y, lthing.z, LightOpe.SunForceAdd, fget)
				end
				return false
			end
		end
	elseif lightoperation == "NewSunlightDownSubtraction" then
		lthing.query = function()
			if TileLightable(GetVoxel(lthing.x, lthing.y, lthing.z), true) then
				SetVoxelFirstData(lthing.x, lthing.y, lthing.z, Tiles.AIR_Block.id)
				NewLightOperation(lthing.x, lthing.y - 1, lthing.z, LightOpe.SunDownSubtract)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = lthing.x + dir.x
					NewLightOperation(x, lthing.y + dir.y, lthing.z + dir.z, LightOpe.SunSubtract, LightSources[15])
				end
				return true
			end
		end
	end
	return lthing
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
	local updatedT = LightningQueries(t, lightoperation)
	local operationFunction = operationFunctions[lightoperation]
	if operationFunction then
		operationFunction(updatedT)
	else
		ThreadLogChannel:push({
			LuaCraftLoggingLevel.ERROR,
			"This lightoperation: " .. lightoperation .. " is not correct",
		})
	end
end
