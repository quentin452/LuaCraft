-- hash function used in chunk hash table
function ChunkHash(x)
	return x < 0 and 2 * math.abs(x) or 1 + 2 * x
end

function Localize(x, y, z)
	return x % ChunkSize + 1, y, z % ChunkSize + 1
end
function Globalize(cx, cz, x, y, z)
	return (cx - 1) * ChunkSize + x - 1, y, (cz - 1) * ChunkSize + z - 1
end

-- get chunk from reading chunk hash table at given position
function GetChunk(x, y, z)
	-- Récupérer la table de hachage ChunkHashTable du canal de communication
--	ThreadLightingChannel:push({ "GetChunkHashTable" })
--	local ChunkHashTable = ThreadLightingChannel:demand()

	local x = math.floor(x)
	local y = math.floor(y)
	local z = math.floor(z)
	local hashx, hashy = ChunkHash(math.floor(x / ChunkSize) + 1), ChunkHash(math.floor(z / ChunkSize) + 1)
	local getChunk = nil
	if ChunkHashTable[hashx] ~= nil then
		getChunk = ChunkHashTable[hashx][hashy]
	end
	if y < 1 or y > WorldHeight then
		getChunk = nil
	end

	local mx, mz = x % ChunkSize + 1, z % ChunkSize + 1
	return getChunk, mx, y, mz, hashx, hashy
end

function GetChunkRaw(x, z)
	local hashx, hashy = ChunkHash(x), ChunkHash(z)
	local getChunk = nil
	if ChunkHashTable[hashx] ~= nil then
		getChunk = ChunkHashTable[hashx][hashy]
	end
	return getChunk
end
