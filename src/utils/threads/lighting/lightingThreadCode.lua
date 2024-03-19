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

local function LightingUpdate()
	for _, lthing in ipairs(LightingRemovalQueue) do
		lthing:query()
	end
	for _, lthing in ipairs(LightingQueue) do
		lthing:query()
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

local function LightningQueries(self, lightoperation)
	local cget, cx, cy, cz = GetChunk(self.x, self.y, self.z)
	if cget == nil then
		return function() end
	end

	if lightoperation == LightOpe.SunForceAdd then
		return function()
			local val = cget:getVoxel(cx, cy, cz)
			if self.value >= 0 and TileLightable(val, true) then
				cget:setVoxelFirstData(cx, cy, cz, self.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = self.x + dir.x
					NewLightOperation(x, self.y + dir.y, self.z + dir.z, LightOpe.SunAdd, self.value - 1)
				end
			end
		end
	elseif lightoperation == LightOpe.SunCreationAdd then
		return function()
			local val = cget:getVoxel(cx, cy, cz)
			local dat = cget:getVoxelFirstData(cx, cy, cz)
			if TileLightable(val, true) and dat > 0 then
				NewLightOperation(self.x, self.y, self.z, LightOpe.SunForceAdd, dat)
			end
		end
	elseif lightoperation == LightOpe.SunDownAdd then
		return function()
			local val = cget:getVoxel(cx, cy, cz)
			local dat = cget:getVoxelFirstData(cx, cy, cz)
			if TileLightable(val) and dat <= self.value then
				cget:setVoxelFirstData(cx, cy, cz, self.value)
				NewLightOperation(self.x, self.y - 1, self.z, LightOpe.SunDownAdd, self.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = self.x + dir.x
					NewLightOperation(x, self.y + dir.y, self.z + dir.z, LightOpe.SunAdd, self.value - 1)
				end
			end
		end
	elseif lightoperation == LightOpe.LocalForceAdd then
		return function()
			local val, _, _ = cget:getVoxel(cx, cy, cz)
			if self.value >= 0 and TileLightable(val, true) then
				cget:setVoxelSecondData(cx, cy, cz, self.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = self.x + dir.x
					NewLightOperation(x, self.y + dir.y, self.z + dir.z, LightOpe.LocalAdd, self.value - 1)
				end
			end
		end
	elseif lightoperation == LightOpe.LocalSubtract then
		return function()
			local val, _ = cget:getVoxel(cx, cy, cz)
			local fget = cget:getVoxelSecondData(cx, cy, cz)
			if fget > 0 and self.value >= 0 and TileLightable(val, true) then
				if fget < self.value then
					cget:setVoxelSecondData(cx, cy, cz, 0)
					for _, dir in ipairs(SIXDIRECTIONS) do
						local nx, ny, nz = self.x + dir.x, self.y + dir.y, self.z + dir.z
						NewLightOperation(nx, ny, nz, LightOpe.LocalSubtract, fget)
					end
				else
					NewLightOperation(self.x, self.y, self.z, LightOpe.LocalForceAdd, fget)
				end
				return false
			end
		end
	elseif lightoperation == LightOpe.LocalCreationAdd then
		return function()
			local val, _, dat = cget:getVoxel(cx, cy, cz)
			if TileLightable(val, true) and dat > 0 then
				NewLightOperation(self.x, self.y, self.z, LightOpe.LocalForceAdd, dat)
			end
		end
	elseif lightoperation == LightOpe.SunAdd then
		return function()
			local val = cget:getVoxel(cx, cy, cz)
			local dat = cget:getVoxelFirstData(cx, cy, cz)
			if self.value >= 0 and TileLightable(val, true) and dat < self.value then
				cget:setVoxelFirstData(cx, cy, cz, self.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = self.x + dir.x
					NewLightOperation(x, self.y + dir.y, self.z + dir.z, LightOpe.SunAdd, self.value - 1)
				end
			end
		end
	elseif lightoperation == LightOpe.LocalAdd then
		return function()
			local localcx, localcy, localcz = Localize(self.x, self.y, self.z)
			local val, _, dat = cget:getVoxel(localcx, localcy, localcz)
			if TileLightable(val, true) and dat < self.value then
				cget:setVoxelSecondData(localcx, localcy, localcz, self.value)
				if self.value > 1 then
					for _, dir in ipairs(SIXDIRECTIONS) do
						local x = self.x + dir.x
						NewLightOperation(x, self.y + dir.y, self.z + dir.z, LightOpe.LocalAdd, self.value - 1)
					end
				end
			end
		end
	elseif lightoperation == LightOpe.SunSubtract then
		return function()
			local val = cget:getVoxel(cx, cy, cz)
			local fget = cget:getVoxelFirstData(cx, cy, cz)
			if fget > 0 and self.value >= 0 and TileLightable(val, true) then
				if fget < self.value then
					cget:setVoxelFirstData(cx, cy, cz, Tiles.AIR_Block.id)
					for _, dir in ipairs(SIXDIRECTIONS) do
						local x = self.x + dir.x
						NewLightOperation(x, self.y + dir.y, self.z + dir.z, LightOpe.SunSubtract, fget)
					end
				else
					NewLightOperation(self.x, self.y, self.z, LightOpe.SunForceAdd, fget)
				end
				return false
			end
		end
	elseif lightoperation == LightOpe.SunDownSubtract then
		return function()
			if TileLightable(GetVoxel(self.x, self.y, self.z), true) then
				SetVoxelFirstData(self.x, self.y, self.z, Tiles.AIR_Block.id)
				NewLightOperation(self.x, self.y - 1, self.z, LightOpe.SunDownSubtract)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = self.x + dir.x
					NewLightOperation(x, self.y + dir.y, self.z + dir.z, LightOpe.SunSubtract, LightSources[15])
				end
				return true
			end
		end
	end
end
local operationFunctions = {
	[LightOpe.SunForceAdd] = LightingQueueAdd,
	[LightOpe.SunCreationAdd] = LightingQueueAdd,
	[LightOpe.SunDownAdd] = LightingQueueAdd,
	[LightOpe.LocalForceAdd] = LightingQueueAdd,
	[LightOpe.LocalCreationAdd] = LightingQueueAdd,
	[LightOpe.SunAdd] = LightingQueueAdd,
	[LightOpe.LocalAdd] = LightingQueueAdd,
	[LightOpe.LocalSubtract] = LightingRemovalQueueAdd,
	[LightOpe.SunSubtract] = LightingRemovalQueueAdd,
	[LightOpe.SunDownSubtract] = LightingRemovalQueueAdd,
}

local function NewLightOperation(x, y, z, lightoperation, value)
	local t = { x = x, y = y, z = z, value = value }
	t.query = LightningQueries(t, lightoperation)
	local operationFunction = operationFunctions[lightoperation]
	if operationFunction then
		operationFunction(t)
	else
		ThreadLogChannel:push({
			LuaCraftLoggingLevel.ERROR,
			"This lightoperation: " .. lightoperation .. " is not correct",
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
