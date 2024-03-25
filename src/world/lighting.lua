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
function LightingUpdate()
	for _, query in ipairs(LightingRemovalQueue) do
		query()
		query = nil
	end
	LightingRemovalQueue = {}
	for _, query in ipairs(LightingQueue) do
		query()
		query = nil
	end
	LightingQueue = {}
end

function SunForceAdd(cget, cx, cy, cz, value, x, y, z)
	local val = cget:getVoxel(cx, cy, cz)
	if value >= 0 and TileLightable(val, true) then
		cget:setVoxelFirstData(cx, cy, cz, value)
		for _, dir in ipairs(SIXDIRECTIONS) do
			local nx, ny, nz = x + dir.x, y + dir.y, z + dir.z
			NewLightOperation(nx, ny, nz, LightOpe.SunAdd.id, value - 1)
		end
	end
end
function SunCreationAdd(cget, cx, cy, cz, x, y, z)
	local val = cget:getVoxel(cx, cy, cz)
	local dat = cget:getVoxelFirstData(cx, cy, cz)
	if TileLightable(val, true) and dat > 0 then
		NewLightOperation(x, y, z, LightOpe.SunForceAdd.id, dat)
	end
end
function SunDownAdd(cget, cx, cy, cz, value, x, y, z)
	local val = cget:getVoxel(cx, cy, cz)
	local dat = cget:getVoxelFirstData(cx, cy, cz)
	if TileLightable(val) and dat <= value then
		cget:setVoxelFirstData(cx, cy, cz, value)
		NewLightOperation(x, y - 1, z, LightOpe.SunDownAdd.id, value)
		for _, dir in ipairs(FOURDIRECTIONS) do
			local nx, ny, nz = x + dir.x, y + dir.y, z + dir.z
			NewLightOperation(nx, ny, nz, LightOpe.SunAdd.id, value - 1)
		end
	end
end

function LocalForceAdd(cget, cx, cy, cz, value, x, y, z)
	local val, _, _ = cget:getVoxel(cx, cy, cz)
	if value >= 0 and TileLightable(val, true) then
		cget:setVoxelSecondData(cx, cy, cz, value)
		for _, dir in ipairs(SIXDIRECTIONS) do
			NewLightOperation(x + dir.x, y + dir.y, z + dir.z, LightOpe.LocalAdd.id, value - 1)
		end
	end
end

function LocalSubtract(cget, cx, cy, cz, value, x, y, z)
	local val, _ = cget:getVoxel(cx, cy, cz)
	local fget = cget:getVoxelSecondData(cx, cy, cz)
	if fget > 0 and value >= 0 and TileLightable(val, true) then
		if fget < value then
			cget:setVoxelSecondData(cx, cy, cz, 0)
			for _, dir in ipairs(SIXDIRECTIONS) do
				local nx, ny, nz = x + dir.x, y + dir.y, z + dir.z
				NewLightOperation(nx, ny, nz, LightOpe.LocalSubtract.id, fget)
			end
		else
			NewLightOperation(x, y, z, LightOpe.LocalForceAdd.id, fget)
		end
		return false
	end
end

function LocalCreationAdd(cget, cx, cy, cz, x, y, z)
	local val, _, dat = cget:getVoxel(cx, cy, cz)
	if TileLightable(val, true) and dat > 0 then
		NewLightOperation(x, y, z, LightOpe.LocalForceAdd.id, dat)
	end
end

function SunAdd(cget, cx, cy, cz, value, x, y, z)
	local val = cget:getVoxel(cx, cy, cz)
	local dat = cget:getVoxelFirstData(cx, cy, cz)
	if value >= 0 and TileLightable(val, true) and dat < value then
		cget:setVoxelFirstData(cx, cy, cz, value)
		for _, dir in ipairs(SIXDIRECTIONS) do
			NewLightOperation(x + dir.x, y + dir.y, z + dir.z, LightOpe.SunAdd.id, value - 1)
		end
	end
end
function LocalAdd(cget, value, x, y, z)
	local localcx, localcy, localcz = Localize(x, y, z)
	local val, _, dat = cget:getVoxel(localcx, localcy, localcz)
	if TileLightable(val, true) and dat < value then
		cget:setVoxelSecondData(localcx, localcy, localcz, value)
		if value > 1 then
			for _, dir in ipairs(SIXDIRECTIONS) do
				NewLightOperation(x + dir.x, y + dir.y, z + dir.z, LightOpe.LocalAdd.id, value - 1)
			end
		end
	end
end
function SunSubtract(cget, cx, cy, cz, value, x, y, z)
	local val = cget:getVoxel(cx, cy, cz)
	local fget = cget:getVoxelFirstData(cx, cy, cz)
	if fget > 0 and value >= 0 and TileLightable(val, true) then
		if fget < value then
			cget:setVoxelFirstData(cx, cy, cz, Tiles.AIR_Block.id)
			for _, dir in ipairs(SIXDIRECTIONS) do
				NewLightOperation(x + dir.x, y + dir.y, z + dir.z, LightOpe.SunSubtract.id, fget)
			end
		else
			NewLightOperation(x, y, z, LightOpe.SunForceAdd.id, fget)
		end
		return false
	end
end
function SunDownSubtract(x, y, z)
	local val = GetVoxel(x, y, z)
	if TileLightable(val, true) then
		SetVoxelFirstData(x, y, z, Tiles.AIR_Block.id)
		NewLightOperation(x, y - 1, z, LightOpe.SunDownSubtract.id)
		for _, dir in ipairs(FOURDIRECTIONS) do
			NewLightOperation(x + dir.x, y + dir.y, z + dir.z, LightOpe.SunSubtract.id, LightSources[15])
		end
		return true
	end
	return false
end

--TODO REMOVE ANONYMES FUNCTION
--TODO REMOVE RECURSIVE CALLS
--TODO put lightning into another thread
local function PerformLightOperation(cget, cx, cy, cz, lightoperation, value, x, y, z)
	if lightoperation == LightOpe.SunForceAdd.id then
		SunForceAdd(cget, cx, cy, cz, value, x, y, z)
	elseif lightoperation == LightOpe.SunCreationAdd.id then
		SunCreationAdd(cget, cx, cy, cz, x, y, z)
	elseif lightoperation == LightOpe.SunDownAdd.id then
		SunDownAdd(cget, cx, cy, cz, value, x, y, z)
	elseif lightoperation == LightOpe.LocalForceAdd.id then
		LocalForceAdd(cget, cx, cy, cz, value, x, y, z)
	elseif lightoperation == LightOpe.LocalSubtract.id then
		LocalSubtract(cget, cx, cy, cz, value, x, y, z)
	elseif lightoperation == LightOpe.LocalCreationAdd.id then
		LocalCreationAdd(cget, cx, cy, cz, x, y, z)
	elseif lightoperation == LightOpe.SunAdd.id then
		SunAdd(cget, cx, cy, cz, value, x, y, z)
	elseif lightoperation == LightOpe.LocalAdd.id then
		LocalAdd(cget, value, x, y, z)
	elseif lightoperation == LightOpe.SunSubtract.id then
		SunSubtract(cget, cx, cy, cz, value, x, y, z)
	elseif lightoperation == LightOpe.SunDownSubtract.id then
		SunDownSubtract(x, y, z)
	end
end

local function LightningQueries(x, y, z, lightoperation, value)
	local cget, cx, cy, cz = GetChunk(x, y, z)
	if cget == nil then
		return
	end
	return function()
		PerformLightOperation(cget, cx, cy, cz, lightoperation, value, x, y, z)
	end
end

function NewLightOperation(x, y, z, lightoperation, value)
	local query
	if EnableLightningEngineDebug == true then
		query = LightningQueriesTestUnit(x, y, z, lightoperation, value)
	else
		query = LightningQueries(x, y, z, lightoperation, value)
	end
	local operation = LightOpe[lightoperation]
	if operation then
		if EnableLightningEngineDebug == true then
			local startTime = love.timer.getTime()
			local operationFunction = operation.lightope
			operationFunction(query)
			local endTime = love.timer.getTime() - startTime
			LightningQueriesTestUnitOperationCounter[lightoperation] = (
				LightningQueriesTestUnitOperationCounter[lightoperation] or 0
			) + 1
			if LightningQueriesTestUnitOperationCounter[lightoperation] <= 1000 then
				ThreadLogChannel:push({
					LuaCraftLoggingLevel.NORMAL,
					lightoperation .. " operation time: " .. endTime .. " seconds",
				})
			end
		else
			local operationFunction = operation.lightope
			operationFunction(query)
		end
	else
		ThreadLogChannel:push({
			LuaCraftLoggingLevel.ERROR,
			"Invalid lightoperation: " .. lightoperation,
		})
	end
	query = nil
end
