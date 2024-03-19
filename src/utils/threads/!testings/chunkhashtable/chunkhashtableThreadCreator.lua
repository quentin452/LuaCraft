--TODO MADE THIS USEFULL : FOR NOW ChunkHashTableChannel made nothing
function createChunkHashTableThread()
	local ChunkHashTableChannel = love.thread.newChannel()
	local thread = love.thread.newThread("src/utils/threads/!testings/chunkhashtable/chunkhashtableThreadCode.lua")
	thread:start(ChunkHashTableChannel,BlockModellingChannel, ChunkHashTable)
	return ChunkHashTableChannel
end
