ChunkHashTableChannel, BlockModellingChannel, ChunkHashTable, ThreadLightingChannel = ...
--TODO MADE THIS USEFULL : FOR NOW ChunkHashTableChannel made nothing
while true do
	local message = ChunkHashTableChannel:demand()
	if message then
		local chunkX, chunkZ = unpack(message)
		print("ChunkHashTableChannel a reçu chunkX: ", chunkX, " chunkZ: ", chunkZ) -- Ajouté pour le débogage
		ChunkHashTable[chunkX] = ChunkHashTable[chunkX] or {}
		ChunkHashTable[chunkX][chunkZ] = true
		--ThreadLightingChannel:push({ "UpdateChunkHashTable", chunkX, chunkZ })
	end
end
