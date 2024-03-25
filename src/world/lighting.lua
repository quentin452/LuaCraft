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

local function PerformLightLoop(x, y, z, tablechoosed, lightoperation, value)
	for _, dir in ipairs(tablechoosed) do
		NewLightOperation(x + dir.x, y + dir.y, z + dir.z, lightoperation, value)
	end
end
--TODO REMOVE ANONYMES FUNCTION
--TODO REMOVE RECURSIVE CALLS
--TODO put lightning into another thread
function PerformLightOperation(cget, cx, cy, cz, lightoperation, value, x, y, z)
	if lightoperation == LightOpe.SunForceAdd.id then
		local val = cget:getVoxel(cx, cy, cz)
		if value >= 0 and TileLightable(val, true) then
			cget:setVoxelFirstData(cx, cy, cz, value)
			PerformLightLoop(x, y, z, SIXDIRECTIONS, LightOpe.SunAdd.id, value - 1)
		end
	elseif lightoperation == LightOpe.SunCreationAdd.id then
		local val = cget:getVoxel(cx, cy, cz)
		local dat = cget:getVoxelFirstData(cx, cy, cz)
		if TileLightable(val, true) and dat > 0 then
			NewLightOperation(x, y, z, LightOpe.SunForceAdd.id, dat)
		end
	elseif lightoperation == LightOpe.SunDownAdd.id then
		local val = cget:getVoxel(cx, cy, cz)
		local dat = cget:getVoxelFirstData(cx, cy, cz)
		if TileLightable(val) and (dat and dat <= value) then
			cget:setVoxelFirstData(cx, cy, cz, value)
			NewLightOperation(x, y - 1, z, LightOpe.SunDownAdd.id, value)
			PerformLightLoop(x, y, z, FOURDIRECTIONS, LightOpe.SunAdd.id, value - 1)
		end
	elseif lightoperation == LightOpe.LocalForceAdd.id then
		local val, _, _ = cget:getVoxel(cx, cy, cz)
		if value >= 0 and TileLightable(val, true) then
			cget:setVoxelSecondData(cx, cy, cz, value)
			PerformLightLoop(x, y, z, SIXDIRECTIONS, LightOpe.LocalAdd.id, value - 1)
		end
	elseif lightoperation == LightOpe.LocalSubtract.id then
		local val, _ = cget:getVoxel(cx, cy, cz)
		local fget = cget:getVoxelSecondData(cx, cy, cz)
		if fget > 0 and value >= 0 and TileLightable(val, true) then
			if fget < value then
				cget:setVoxelSecondData(cx, cy, cz, 0)
				PerformLightLoop(x, y, z, SIXDIRECTIONS, LightOpe.LocalSubtract.id, fget)
			else
				NewLightOperation(x, y, z, LightOpe.LocalForceAdd.id, fget)
			end
			return false
		end
	elseif lightoperation == LightOpe.LocalCreationAdd.id then
		local val, _, dat = cget:getVoxel(cx, cy, cz)
		if TileLightable(val, true) and dat > 0 then
			NewLightOperation(x, y, z, LightOpe.LocalForceAdd.id, dat)
		end
	elseif lightoperation == LightOpe.SunAdd.id then
		local val = cget:getVoxel(cx, cy, cz)
		local dat = cget:getVoxelFirstData(cx, cy, cz)
		if value >= 0 and TileLightable(val, true) and dat < value then
			cget:setVoxelFirstData(cx, cy, cz, value)
			PerformLightLoop(x, y, z, SIXDIRECTIONS, LightOpe.SunAdd.id, value - 1)
		end
	elseif lightoperation == LightOpe.LocalAdd.id then
		local localcx, localcy, localcz = Localize(x, y, z)
		local val, _, dat = cget:getVoxel(localcx, localcy, localcz)
		if TileLightable(val, true) and dat < value then
			cget:setVoxelSecondData(localcx, localcy, localcz, value)
			if value > 1 then
				PerformLightLoop(x, y, z, SIXDIRECTIONS, LightOpe.LocalAdd.id, value - 1)
			end
		end
	elseif lightoperation == LightOpe.SunSubtract.id then
		local val = cget:getVoxel(cx, cy, cz)
		local fget = cget:getVoxelFirstData(cx, cy, cz)
		if fget > 0 and value >= 0 and TileLightable(val, true) then
			if fget < value then
				cget:setVoxelFirstData(cx, cy, cz, Tiles.AIR_Block.id)
				PerformLightLoop(x, y, z, SIXDIRECTIONS, LightOpe.SunSubtract.id, fget)
			else
				NewLightOperation(x, y, z, LightOpe.SunForceAdd.id, fget)
			end
			return false
		end
	elseif lightoperation == LightOpe.SunDownSubtract.id then
		local val = GetVoxel(x, y, z)
		if TileLightable(val, true) then
			SetVoxelFirstData(x, y, z, Tiles.AIR_Block.id)
			PerformLightLoop(x, y, z, FOURDIRECTIONS, LightOpe.SunSubtract.id, LightSources[15])
			if GetVoxel(x, y - 1, z) == Tiles.AIR_Block.id or TileModel(GetVoxel(x, y - 1, z)) == 1 then
				NewLightOperation(x, y - 1, z, LightOpe.SunDownSubtract.id)
			end
			return true
		end
		return false
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
local function isSubtractOperation(lightoperation)
	return lightoperation == LightOpe.SunSubtract.id
		or lightoperation == LightOpe.SunDownSubtract.id
		or lightoperation == LightOpe.LocalSubtract.id
end

function ChooseLightingQueue(lightoperation, query)
	if isSubtractOperation(lightoperation) then
		LightingRemovalQueue[#LightingRemovalQueue + 1] = query
	else
		LightingQueue[#LightingQueue + 1] = query
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
			NewLightOperationTestUnit(query, lightoperation)
		else
			ChooseLightingQueue(lightoperation, query)
		end
	end
	query = nil
end
