function createLightningThread()
	local ThreadLightingChannel = love.thread.newChannel()
	local thread = love.thread.newThread("src/utils/threads/lighting/lightingThreadCode.lua")
	thread:start(
		ThreadLightingChannel,
		LightOpe,
		LightingChannel,
		ThreadLogChannel,
		LuaCraftLoggingLevel,
		Tiles,
		TilesTransparency,
		ChunkSize,
		ChunkHashTable,
		TilesById
	)
	return ThreadLightingChannel
end
