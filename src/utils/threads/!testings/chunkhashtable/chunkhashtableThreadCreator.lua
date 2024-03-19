function createChunkHashTableThread()
	local ChunkHashTableChannel = love.thread.newChannel()
	local thread = love.thread.newThread("src/utils/threads/!testings/chunkhashtable/chunkhashtableThreadCode.lua")
	thread:start(ChunkHashTableChannel, ChunkHashTableTesting)
	return ChunkHashTableChannel
end
