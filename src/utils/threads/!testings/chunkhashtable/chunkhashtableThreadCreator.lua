--TODO MADE THIS USEFULL : FOR NOW ChunkHashTableChannel made nothing
function createChunkHashTableThread()
	local thread = love.thread.newThread("src/utils/threads/!testings/chunkhashtable/chunkhashtableThreadCode.lua")
	thread:start(ChunkHashTableChannel, BlockModellingChannel, ChunkHashTable, ThreadLightingChannel)
	return ChunkHashTableChannel
end
