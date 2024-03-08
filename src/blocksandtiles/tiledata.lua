tileModelCache = {}
tile2DCache = {}
lightSourceCache = {}
transparencyCache = {}

function InitializeTilesNumberAndName()
	LuaCraftPrintLoggingNormal("Initializing tiles...")
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
	TilesString = {
		AIR_Block = "AIR_Block",
		STONE_Block = "STONE_Block",
		GRASS_Block = "GRASS_Block",
		DIRT_Block = "DIRT_Block",
		COBBLE_Block = "COBBLE_Block",
		OAK_PLANK_Block = "OAK_PLANK_Block",
		OAK_SAPPLING_Block = "OAK_SAPPLING_Block",
		BEDROCK_Block = "BEDROCK_Block",
		WATER_Block = "WATER_Block",
		STATIONARY_WATER_Block = "STATIONARY_WATER_Block",
		LAVA_Block = "LAVA_Block",
		STATIONARY_LAVA_Block = "STATIONARY_LAVA_Block",
		SAND_Block = "SAND_Block",
		GRAVEL_Block = "GRAVEL_Block",
		GOLD_Block = "GOLD_Block",
		IRON_Block = "IRON_Block",
		COAL_Block = "COAL_Block",
		OAK_LOG_Block = "OAK_LOG_Block",
		OAK_LEAVE_Block = "OAK_LEAVE_Block",
		SPONGE_Block = "SPONGE_Block",
		GLASS_Block = "GLASS_Block",
		YELLO_FLOWER_Block = "YELLO_FLOWER_Block",
		ROSE_FLOWER_Block = "ROSE_FLOWER_Block",
		STONE_BRICK_Block = "STONE_BRICK_Block",
		GLOWSTONE_Block = "GLOWSTONE_Block",
	}
	TilesTransparency = {
		FULL = 0,
		PARTIAL = 1,
		NONE = 2,
		OPAQUE = 3,
	}
	transparencyLookup = {
		[Tiles.AIR_Block] = TilesTransparency.FULL,
		[Tiles.YELLO_FLOWER_Block] = TilesTransparency.FULL,
		[Tiles.ROSE_FLOWER_Block] = TilesTransparency.FULL,
		[Tiles.OAK_SAPPLING_Block] = TilesTransparency.FULL,
		[Tiles.OAK_LEAVE_Block] = TilesTransparency.PARTIAL,
		[Tiles.GLASS_Block] = TilesTransparency.NONE,
		[Tiles.GLOWSTONE_Block] = TilesTransparency.NONE,
		[Tiles.STONE_Block] = TilesTransparency.OPAQUE,
		[Tiles.GRASS_Block] = TilesTransparency.OPAQUE,
		[Tiles.DIRT_Block] = TilesTransparency.OPAQUE,
		[Tiles.COBBLE_Block] = TilesTransparency.OPAQUE,
		[Tiles.OAK_PLANK_Block] = TilesTransparency.OPAQUE,
		[Tiles.BEDROCK_Block] = TilesTransparency.OPAQUE,
		[Tiles.WATER_Block] = TilesTransparency.OPAQUE,
		[Tiles.STATIONARY_WATER_Block] = TilesTransparency.OPAQUE,
		[Tiles.LAVA_Block] = TilesTransparency.OPAQUE,
		[Tiles.STATIONARY_LAVA_Block] = TilesTransparency.OPAQUE,
		[Tiles.SAND_Block] = TilesTransparency.OPAQUE,
		[Tiles.GRAVEL_Block] = TilesTransparency.OPAQUE,
		[Tiles.GOLD_Block] = TilesTransparency.OPAQUE,
		[Tiles.IRON_Block] = TilesTransparency.OPAQUE,
		[Tiles.COAL_Block] = TilesTransparency.OPAQUE,
		[Tiles.OAK_LOG_Block] = TilesTransparency.OPAQUE,
		[Tiles.SPONGE_Block] = TilesTransparency.OPAQUE,
		[Tiles.STONE_BRICK_Block] = TilesTransparency.OPAQUE,
	}
	lightSourceLookup = {
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
	local indices = {}
	for key, value in pairs(Tiles) do
		assert(indices[value] == nil, "Duplicate index in Tiles Table: " .. tostring(value))
		assert(TilesString[key] ~= nil, "Key not found in TilesString: " .. tostring(key))
		indices[value] = key
		LuaCraftPrintLoggingNormal(
			"Tile Name: "
				.. key
				.. " Tile Index: "
				.. tostring(value)
				.. " Tile Transparency: "
				.. tostring(transparencyLookup[value])
				.. " Tile Light Source: "
				.. tostring(lightSourceLookup[value])
				.. "\n-----------------------------------------------------------------------------------------------------------------------"
		)
	end
	indices = {}
	LuaCraftPrintLoggingNormal("Tiles initialized!")
end

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
	_JPROFILER.push("TileCollisions")
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
			_JPROFILER.pop("TileCollisions")
			return false
		end
	end
	_JPROFILER.pop("TileCollisions")
	return true
end

local function getTileName(n)
	_JPROFILER.push("getTileNameTILEDATA")
	for key, value in pairs(Tiles) do
		if value == n then
			_JPROFILER.pop("getTileNameTILEDATA")
			return TilesString[key]
		end
	end
	_JPROFILER.pop("getTileNameTILEDATA")
	return "Unknown"
end

function TileTransparency(n)
	_JPROFILER.push("TileTransparency")
	if transparencyCache[n] then
		_JPROFILER.pop("TileTransparency")
		return transparencyCache[n]
	else
		assert(transparencyLookup[n] ~= nil, "Key not found in transparencyLookup: " .. getTileName(n))
		local transparency = transparencyLookup[n]
		transparencyCache[n] = transparency
		_JPROFILER.pop("TileTransparency")
		return transparency
	end
end

function TileLightSource(n)
	_JPROFILER.push("TileLightSource")
	if lightSourceCache[n] ~= nil then
		_JPROFILER.pop("TileLightSource")
		return lightSourceCache[n]
	end
	assert(lightSourceLookup[n] ~= nil, "Key not found in lightSourceLookup: " .. getTileName(n))
	local result = lightSourceLookup[n]
	lightSourceCache[n] = result
	_JPROFILER.pop("TileLightSource")
	return result
end

function TileLightable(n)
	_JPROFILER.push("TileLightable")
	local t = TileTransparency(n)
	_JPROFILER.pop("TileLightable")
	return t == TilesTransparency.FULL or t == TilesTransparency.NONE
end

function TileSemiLightable(n)
	_JPROFILER.push("TileSemiLightable")
	local t = TileTransparency(n)
	_JPROFILER.pop("TileSemiLightable")
	return t == TilesTransparency.FULL or t == TilesTransparency.PARTIAL or t == TilesTransparency.NONE
end

function TileTextures(n)
	assert(TilesTextureList[n] ~= nil, "Key not found in TilesTextureList: " .. getTileName(n))
	return TilesTextureList[n]
end
function TileTexturesFORHUD(n)
	assert(TilesTextureListHUD[n] ~= nil, "Key not found in TilesTextureListHUD: " .. getTileName(n))
	return TilesTextureListHUD[n]
end
function TileModel(n)
	_JPROFILER.push("TileModel")
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
	_JPROFILER.pop("TileModel")
	return result
end

function Tile2D(n)
	_JPROFILER.push("Tile2D")
	if tile2DCache[n] then
		return tile2DCache[n]
	end
	local result = n == Tiles.YELLO_FLOWER_Block or n == Tiles.ROSE_FLOWER_Block or n == Tiles.OAK_SAPPLING_Block
	tile2DCache[n] = result
	_JPROFILER.pop("Tile2D")
	return result
end
