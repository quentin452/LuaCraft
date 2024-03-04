tileTexturesCache = {}
tileModelCache = {}
tile2DCache = {}
lightSourceCache = {}
transparencyCache = {}

Tiles = {
	AIR_Block = 0,
	STONE_Block = 1,
	GRASS_Block = 2,
	DIRT_Block = 3,
	COBBLE_Block = 4,
	OAK_PLANK_Block = 5,
	OAK_SAPPLING_Block = 6,
	BEDROCK_Block = 7,
	WATER_Block = 8,
	STATIONARY_WATER_Block = 9,
	LAVA_Block = 10,
	STATIONARY_LAVA_Block = 11,
	SAND_Block = 12,
	GRAVEL_Block = 13,
	GOLD_Block = 14,
	IRON_Block = 15,
	COAL_Block = 16,
	OAK_LOG_Block = 17,
	OAK_LEAVE_Block = 18,
	SPONGE_Block = 19,
	GLASS_Block = 20,
	YELLO_FLOWER_Block = 37,
	ROSE_FLOWER_Block = 38,
	STONE_BRICK_Block = 45,
	GLOWSTONE_Block = 89,
}
local transparencyLookup = {
	[Tiles.AIR_Block] = 0,
	[Tiles.YELLO_FLOWER_Block] = 0,
	[Tiles.ROSE_FLOWER_Block] = 0,
	[Tiles.OAK_SAPPLING_Block] = 0,
	[Tiles.OAK_LEAVE_Block] = 1,
	[Tiles.GLASS_Block] = 2,
	[Tiles.GLOWSTONE_Block] = 2,
}
LightSources = {
	[0] = 0,
	[1] = 1,
	[2] = 2,
	[3] = 3,
	[4] = 4,
	[5] = 5,
	[6] = 6,
	[7] = 7,
	[8] = 8,
	[9] = 9,
	[10] = 10,
	[11] = 11,
	[12] = 12,
	[13] = 13,
	[14] = 14,
	[15] = 15,
}
function TileCollisions(n)
	local nonCollidableTiles = {
		Tiles.AIR_Block,
		Tiles.OAK_SAPPLING_Block,
		Tiles.WATER_Block,
		Tiles.STATIONARY_WATER_Block,
		Tiles.LAVA_Block,
		Tiles.STATIONARY_LAVA_Block,
		Tiles.YELLO_FLOWER_Block,
		Tiles.ROSE_FLOWER_Block,
	}

	for _, tile in ipairs(nonCollidableTiles) do
		if n == tile then
			return false
		end
	end

	return true
end

function TileTransparency(n)
	if transparencyCache[n] then
		return transparencyCache[n]
	else
		local transparency = transparencyLookup[n] or 3
		transparencyCache[n] = transparency
		return transparency
	end
end

function TileLightSource(n)
	if lightSourceCache[n] ~= nil then
		return lightSourceCache[n]
	end
	local result
	if n == Tiles.GLOWSTONE_Block then
		result = LightSources[15]
	else
		result = LightSources[0]
	end
	lightSourceCache[n] = result
	return result
end

function TileLightable(n)
	local t = TileTransparency(n)
	return t == 0 or t == 2
end

function TileSemiLightable(n)
	local t = TileTransparency(n)
	return t == 0 or t == 1 or t == 2
end
local list = {
	[Tiles.AIR_Block] = { 0 },
	[Tiles.STONE_Block] = { 1 },
	[Tiles.GRASS_Block] = { 3, 0, 2 },
	[Tiles.DIRT_Block] = { 2 },
	[Tiles.COBBLE_Block] = { 16 },
	[Tiles.OAK_PLANK_Block] = { 4 },
	[Tiles.OAK_SAPPLING_Block] = { 15 },
	[Tiles.BEDROCK_Block] = { 17 },
	[Tiles.WATER_Block] = { 14 },
	[Tiles.STATIONARY_WATER_Block] = { 14 },
	[Tiles.LAVA_Block] = { 63 },
	[Tiles.STATIONARY_LAVA_Block] = { 63 },
	[Tiles.SAND_Block] = { 18 },
	[Tiles.GRAVEL_Block] = { 19 },
	[Tiles.GOLD_Block] = { 32 },
	[Tiles.IRON_Block] = { 33 },
	[Tiles.COAL_Block] = { 34 },
	[Tiles.OAK_LOG_Block] = { 20, 21, 21 },
	[Tiles.OAK_LEAVE_Block] = { 52 },
	[Tiles.SPONGE_Block] = { 48 },
	[Tiles.GLASS_Block] = { 49 },
	[Tiles.ROSE_FLOWER_Block] = { 13 },
	[Tiles.YELLO_FLOWER_Block] = { 12 },
	[Tiles.STONE_BRICK_Block] = { 7 },
	[Tiles.GLOWSTONE_Block] = { 105 },
}
function TileTextures(n)
	if tileTexturesCache[n] then
		return tileTexturesCache[n]
	end

	tileTexturesCache[n] = list[n]

	return tileTexturesCache[n]
end
function TileModel(n)
	if tileModelCache[n] then
		return tileModelCache[n]
	end
	local result
	if n == Tiles.YELLO_FLOWER_Block or n == Tiles.ROSE_FLOWER_Block or n == Tiles.OAK_SAPPLING_Block then
		result = 1
	else
		result = 0
	end
	tileModelCache[n] = result
	return result
end

function Tile2D(n)
	if tile2DCache[n] then
		return tile2DCache[n]
	end
	local result = n == Tiles.YELLO_FLOWER_Block or n == Tiles.ROSE_FLOWER_Block or n == Tiles.OAK_SAPPLING_Block
	tile2DCache[n] = result
	return result
end
