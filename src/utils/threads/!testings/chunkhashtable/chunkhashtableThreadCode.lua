ChunkHashTableChannel, ChunkHashTable = ...
--TODO MADE THIS USEFULL : FOR NOW ChunkHashTableChannel made nothing
while true do
	local message = ChunkHashTableChannel:demand()
	if message then
		local chunkX, chunkZ = unpack(message)
		ChunkHashTable[chunkX] = ChunkHashTable[chunkX] or {}
		ChunkHashTable[chunkX][chunkZ] = true
	end
end
