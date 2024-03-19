ThreadLightingChannel, LightOpe, LightingChannel, ThreadLogChannel, LuaCraftLoggingLevel, Tiles, TilesTransparency, ChunkSize, ChunkHashTable, TilesById =
	
...
local WorldHeight = 128
local SIXDIRECTIONS = {
	{ x = 0, y = -1, z = 0 }, -- Down
	{ x = 0, y = 1, z = 0 }, -- Up
	{ x = 1, y = 0, z = 0 }, -- Right
	{ x = -1, y = 0, z = 0 }, -- Left
	{ x = 0, y = 0, z = 1 }, -- Forward
	{ x = 0, y = 0, z = -1 }, -- Backward
}

local function GetValueFromTilesById(n)
	return TilesById[n]
end
local function TileTransparency(n)
	--	if TileTransparencyCache[n] ~= nil then
	--		return TileTransparencyCache[n]
	--	end
	local value = GetValueFromTilesById(n)
	if value then
		local blockstringname = value.blockstringname
		local transparency = Tiles[blockstringname].transparency
		--		TileTransparencyCache[n] = transparency
		return transparency
	end
end
local function TileLightable(n, includePartial)
	local t = TileTransparency(n)
	return (t == TilesTransparency.FULL or t == TilesTransparency.NONE)
		or (includePartial and t == TilesTransparency.PARTIAL)
end

local LightingQueue = {}
local LightingRemovalQueue = {}

local function LightingUpdate()
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
local function ChunkHash(x)
	return x < 0 and 2 * math.abs(x) or 1 + 2 * x
end
local function GetChunk(x, y, z)
	local x = math.floor(x)
	local y = math.floor(y)
	local z = math.floor(z)
	local hashx, hashy = ChunkHash(math.floor(x / ChunkSize) + 1), ChunkHash(math.floor(z / ChunkSize) + 1)
	local getChunk = nil
	if ChunkHashTable[hashx] ~= nil then
		getChunk = ChunkHashTable[hashx][hashy]
		print("ChunkHashTable contains data at hashx:", hashx, "hashy:", hashy)
	else
		print("ChunkHashTable is empty at hashx:", hashx, "hashy:", hashy)
	end
	if y < 1 or y > WorldHeight then
		getChunk = nil
	end
	local mx, mz = x % ChunkSize + 1, z % ChunkSize + 1
	return getChunk, mx, y, mz, hashx, hashy
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


local function NewLightOperation(x, y, z, lightoperation, value)
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
--todo fix something whent wrong here , he do not update Lightning in the game....
while true do
	local message1 = ThreadLightingChannel:demand()
	if message1 then
		local action = message1[1]
		if action == "UpdateChunkHashTable" then
			local chunkX, chunkZ = unpack(message1, 2) -- Récupération des valeurs chunkX et chunkZ
			print("chunkX:", chunkX, "chunkZ:", chunkZ) -- Afficher les valeurs pour déboguer
			ChunkHashTable[chunkX] = ChunkHashTable[chunkX] or {}
			ChunkHashTable[chunkX][chunkZ] = true
		elseif action == "LightOperation" then
			local x, y, z, lightoperation, value = unpack(message1, 2)
			NewLightOperation(x, y, z, lightoperation, value)
			print("Message LightOperation traité avec succès")
		elseif action == "updateLighting" then
			LightingUpdate()
			print("Canal d'éclairage mis à jour")
		else
			print("Action non reconnue")
		end
	else
		print("Aucun message reçu du canal ThreadLightingChannel")
	end
end
