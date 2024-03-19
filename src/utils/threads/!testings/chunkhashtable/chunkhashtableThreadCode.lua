ChunkHashTableChannel, BlockModellingChannel, ChunkHashTable = ...
--TODO MADE THIS USEFULL : FOR NOW ChunkHashTableChannel made nothing
while true do
	local message = ChunkHashTableChannel:demand()
	if message then
		local chunkX, chunkZ = unpack(message)
		print("ChunkHashTableChannel a reçu chunkX: ", chunkX, " chunkZ: ", chunkZ) -- Ajouté pour le débogage
		ChunkHashTable[chunkX] = ChunkHashTable[chunkX] or {}
		ChunkHashTable[chunkX][chunkZ] = true
		BlockModellingChannel:push({ chunkX, chunkZ })
	end
end
