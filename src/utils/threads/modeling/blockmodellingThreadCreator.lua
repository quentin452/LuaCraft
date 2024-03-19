function createBlockModellingThread()
	local BlockModellingChannel = love.thread.newChannel()
	local thread = love.thread.newThread("src/utils/threads/modeling/blockmodellingThreadCode.lua")
	thread:start(
		BlockModellingChannel,
		ChunkSize,
		ChunkHashTable,
		WorldHeight,
		TilesTextureList,
		ChunkHashTableChannel,
		TilesById,
		TileTransparencyCache,
		Tiles,
		TilesTransparency,
		BlockGetTop,
		BlockGetBottom,
		BlockGetPositiveX,
		BlockGetNegativeX,
		BlockGetPositiveZ,
		BlockGetNegativeZ,
		FinalAtlasSize,
		LightValues,
		TileWidth,
		TileHeight
	)
	return BlockModellingChannel
end
