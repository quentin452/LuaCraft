tileModelCache = {}
tile2DCache = {}
lightSourceCache = {}
transparencyCache = {}

--TODO CHANGES NUMBER HERE TO BE STRING FOR MAINTAINABILITY
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
	YELLO_FLOWER_Block = 21,
	ROSE_FLOWER_Block = 22,
	STONE_BRICK_Block = 23,
	GLOWSTONE_Block = 24,
}

local Transparency = {
	FULL = 0,
	PARTIAL = 1,
	NONE = 2,
	OPAQUE = 3,
}
local transparencyLookup = {
	[Tiles.AIR_Block] = Transparency.FULL,
	[Tiles.YELLO_FLOWER_Block] = Transparency.FULL,
	[Tiles.ROSE_FLOWER_Block] = Transparency.FULL,
	[Tiles.OAK_SAPPLING_Block] = Transparency.FULL,
	[Tiles.OAK_LEAVE_Block] = Transparency.PARTIAL,
	[Tiles.GLASS_Block] = Transparency.NONE,
	[Tiles.GLOWSTONE_Block] = Transparency.NONE,
	[Tiles.STONE_Block] = Transparency.OPAQUE,
	[Tiles.GRASS_Block] = Transparency.OPAQUE,
	[Tiles.DIRT_Block] = Transparency.OPAQUE,
	[Tiles.COBBLE_Block] = Transparency.OPAQUE,
	[Tiles.OAK_PLANK_Block] = Transparency.OPAQUE,
	[Tiles.BEDROCK_Block] = Transparency.OPAQUE,
	[Tiles.WATER_Block] = Transparency.OPAQUE,
	[Tiles.STATIONARY_WATER_Block] = Transparency.OPAQUE,
	[Tiles.LAVA_Block] = Transparency.OPAQUE,
	[Tiles.STATIONARY_LAVA_Block] = Transparency.OPAQUE,
	[Tiles.SAND_Block] = Transparency.OPAQUE,
	[Tiles.GRAVEL_Block] = Transparency.OPAQUE,
	[Tiles.GOLD_Block] = Transparency.OPAQUE,
	[Tiles.IRON_Block] = Transparency.OPAQUE,
	[Tiles.COAL_Block] = Transparency.OPAQUE,
	[Tiles.OAK_LOG_Block] = Transparency.OPAQUE,
	[Tiles.SPONGE_Block] = Transparency.OPAQUE,
	[Tiles.STONE_BRICK_Block] = Transparency.OPAQUE,
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
local lightSourceLookup = {
	[Tiles.AIR_Block] = LightSources[0],
	[Tiles.STONE_Block] = LightSources[0],
	[Tiles.GRASS_Block] = LightSources[0],
	[Tiles.DIRT_Block] = LightSources[0],
	[Tiles.COBBLE_Block] = LightSources[0],
	[Tiles.OAK_PLANK_Block] = LightSources[0],
	[Tiles.OAK_SAPPLING_Block] = LightSources[0],
	[Tiles.BEDROCK_Block] = LightSources[0],
	[Tiles.WATER_Block] = LightSources[0],
	[Tiles.STATIONARY_WATER_Block] = LightSources[0],
	[Tiles.LAVA_Block] = LightSources[0],
	[Tiles.STATIONARY_LAVA_Block] = LightSources[0],
	[Tiles.SAND_Block] = LightSources[0],
	[Tiles.GRAVEL_Block] = LightSources[0],
	[Tiles.GOLD_Block] = LightSources[0],
	[Tiles.IRON_Block] = LightSources[0],
	[Tiles.COAL_Block] = LightSources[0],
	[Tiles.OAK_LOG_Block] = LightSources[0],
	[Tiles.OAK_LEAVE_Block] = LightSources[0],
	[Tiles.SPONGE_Block] = LightSources[0],
	[Tiles.GLASS_Block] = LightSources[0],
	[Tiles.YELLO_FLOWER_Block] = LightSources[0],
	[Tiles.ROSE_FLOWER_Block] = LightSources[0],
	[Tiles.STONE_BRICK_Block] = LightSources[0],
	[Tiles.GLOWSTONE_Block] = LightSources[15],
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
		assert(transparencyLookup[n] ~= nil, "Key not found in transparencyLookup: " .. tostring(n))
		local transparency = transparencyLookup[n]
		transparencyCache[n] = transparency
		return transparency
	end
end

function TileLightSource(n)
	if lightSourceCache[n] ~= nil then
		return lightSourceCache[n]
	end
	assert(lightSourceLookup[n] ~= nil, "Key not found in lightSourceLookup: " .. tostring(n))
	local result = lightSourceLookup[n]
	lightSourceCache[n] = result
	return result
end

function TileLightable(n)
	local t = TileTransparency(n)
	return t == Transparency.FULL or t == Transparency.NONE
end

function TileSemiLightable(n)
	local t = TileTransparency(n)
	return t == Transparency.FULL or t == Transparency.PARTIAL or t == Transparency.NONE
end

function TileTextures(n)
	assert(TilesTextureList[n] ~= nil, "Key not found in TilesTextureList: " .. tostring(n))
	return TilesTextureList[n]
end
function TileTexturesFORHUD(n)
	assert(TilesTextureListHUD[n] ~= nil, "Key not found in TilesTextureListHUD: " .. tostring(n))
	return TilesTextureListHUD[n]
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
