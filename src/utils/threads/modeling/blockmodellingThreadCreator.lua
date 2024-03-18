function createBlockModellingThread()
	local BlockModellingChannel = love.thread.newChannel()
	local thread = love.thread.newThread("src/utils/threads/modeling/blockmodellingThreadCode.lua")
	thread:start(BlockModellingChannel, ChunkSize, ChunkHashTable, WorldHeight)
	return BlockModellingChannel
end
