--TODO put lightning into another thread
local SIXDIRECTIONS = {
	{ x = 0, y = -1, z = 0 }, -- Down
	{ x = 0, y = 1, z = 0 }, -- Up
	{ x = 1, y = 0, z = 0 }, -- Right
	{ x = -1, y = 0, z = 0 }, -- Left
	{ x = 0, y = 0, z = 1 }, -- Forward
	{ x = 0, y = 0, z = -1 }, -- Backward
}

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

	lthing.query = function()
		if lightoperation == LightOpe.SunForceAdd.id then
			local val = cget:getVoxel(cx, cy, cz)
			if lthing.value >= 0 and TileLightable(val, true) then
				cget:setVoxelFirstData(cx, cy, cz, lthing.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = lthing.x + dir.x
					NewLightOperation(x, lthing.y + dir.y, lthing.z + dir.z, LightOpe.SunAdd.id, lthing.value - 1)
				end
			end
		elseif lightoperation == LightOpe.SunCreationAdd.id then
			local val = cget:getVoxel(cx, cy, cz)
			local dat = cget:getVoxelFirstData(cx, cy, cz)
			if TileLightable(val, true) and dat > 0 then
				NewLightOperation(lthing.x, lthing.y, lthing.z, LightOpe.SunForceAdd.id, dat)
			end
		elseif lightoperation == LightOpe.SunDownAdd.id then
			local val = cget:getVoxel(cx, cy, cz)
			local dat = cget:getVoxelFirstData(cx, cy, cz)
			if TileLightable(val) and dat <= lthing.value then
				cget:setVoxelFirstData(cx, cy, cz, lthing.value)
				NewLightOperation(lthing.x, lthing.y - 1, lthing.z, LightOpe.SunDownAdd.id, lthing.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = lthing.x + dir.x
					NewLightOperation(x, lthing.y + dir.y, lthing.z + dir.z, LightOpe.SunAdd.id, lthing.value - 1)
				end
			end
		elseif lightoperation == LightOpe.LocalForceAdd.id then
			local val, _, _ = cget:getVoxel(cx, cy, cz)
			if lthing.value >= 0 and TileLightable(val, true) then
				cget:setVoxelSecondData(cx, cy, cz, lthing.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = lthing.x + dir.x
					NewLightOperation(x, lthing.y + dir.y, lthing.z + dir.z, LightOpe.LocalAdd.id, lthing.value - 1)
				end
			end
		elseif lightoperation == LightOpe.LocalSubtract.id then
			local val, _ = cget:getVoxel(cx, cy, cz)
			local fget = cget:getVoxelSecondData(cx, cy, cz)
			if fget > 0 and lthing.value >= 0 and TileLightable(val, true) then
				if fget < lthing.value then
					cget:setVoxelSecondData(cx, cy, cz, 0)
					for _, dir in ipairs(SIXDIRECTIONS) do
						local nx, ny, nz = lthing.x + dir.x, lthing.y + dir.y, lthing.z + dir.z
						NewLightOperation(nx, ny, nz, LightOpe.LocalSubtract.id, fget)
					end
				else
					NewLightOperation(lthing.x, lthing.y, lthing.z, LightOpe.LocalForceAdd.id, fget)
				end
				return false
			end
		elseif lightoperation == LightOpe.LocalCreationAdd.id then
			local val, _, dat = cget:getVoxel(cx, cy, cz)
			if TileLightable(val, true) and dat > 0 then
				NewLightOperation(lthing.x, lthing.y, lthing.z, LightOpe.LocalForceAdd.id, dat)
			end
		elseif lightoperation == LightOpe.SunAdd.id then
			local val = cget:getVoxel(cx, cy, cz)
			local dat = cget:getVoxelFirstData(cx, cy, cz)
			if lthing.value >= 0 and TileLightable(val, true) and dat < lthing.value then
				cget:setVoxelFirstData(cx, cy, cz, lthing.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = lthing.x + dir.x
					NewLightOperation(x, lthing.y + dir.y, lthing.z + dir.z, LightOpe.SunAdd.id, lthing.value - 1)
				end
			end
		elseif lightoperation == LightOpe.LocalAdd.id then
			local localcx, localcy, localcz = Localize(lthing.x, lthing.y, lthing.z)
			local val, _, dat = cget:getVoxel(localcx, localcy, localcz)
			if TileLightable(val, true) and dat < lthing.value then
				cget:setVoxelSecondData(localcx, localcy, localcz, lthing.value)
				if lthing.value > 1 then
					for _, dir in ipairs(SIXDIRECTIONS) do
						local x = lthing.x + dir.x
						NewLightOperation(x, lthing.y + dir.y, lthing.z + dir.z, LightOpe.LocalAdd.id, lthing.value - 1)
					end
				end
			end
		elseif lightoperation == LightOpe.SunSubtract.id then
			local val = cget:getVoxel(cx, cy, cz)
			local fget = cget:getVoxelFirstData(cx, cy, cz)
			if fget > 0 and lthing.value >= 0 and TileLightable(val, true) then
				if fget < lthing.value then
					cget:setVoxelFirstData(cx, cy, cz, Tiles.AIR_Block.id)
					for _, dir in ipairs(SIXDIRECTIONS) do
						local x = lthing.x + dir.x
						NewLightOperation(x, lthing.y + dir.y, lthing.z + dir.z, LightOpe.SunSubtract.id, fget)
					end
				else
					NewLightOperation(lthing.x, lthing.y, lthing.z, LightOpe.SunForceAdd.id, fget)
				end
				return false
			end
		elseif lightoperation == LightOpe.SunDownSubtract.id then
			if TileLightable(GetVoxel(lthing.x, lthing.y, lthing.z), true) then
				SetVoxelFirstData(lthing.x, lthing.y, lthing.z, Tiles.AIR_Block.id)
				NewLightOperation(lthing.x, lthing.y - 1, lthing.z, LightOpe.SunDownSubtract.id)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = lthing.x + dir.x
					NewLightOperation(x, lthing.y + dir.y, lthing.z + dir.z, LightOpe.SunSubtract.id, LightSources[15])
				end
				return true
			end
		end
	end
	return lthing
end

function NewLightOperation(x, y, z, lightoperation, value)
	local t = { x = x, y = y, z = z, value = value }
	local updatedT = LightningQueries(t, lightoperation)
	local operation = LightOpe[lightoperation]
	if operation then
		local operationFunction = operation.lightope
		operationFunction(updatedT)
	else
		ThreadLogChannel:push({
			LuaCraftLoggingLevel.ERROR,
			"Invalid lightoperation: " .. lightoperation,
		})
	end
end
