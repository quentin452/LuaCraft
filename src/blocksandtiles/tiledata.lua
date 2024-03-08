tileModelCache = {}
tile2DCache = {}
lightSourceCache = {}
transparencyCache = {}

Tiles = {
	AIR_Block = 0,
}
function InitializeTilesNumberAndName()
	LuaCraftPrintLoggingNormal("Initializing tiles...")
	for _, func in ipairs(ModLoaderTable["addBlock"]) do
		func()
	end
	TilesString = {}
	for key, _ in pairs(Tiles) do
		TilesString[key] = key
	end
	LuaCraftPrintLoggingNormal(STONE_Block)
	--TODO ADD MOD SUPPORT TILES CATEGORY
	TilesTransparency = {
		FULL = 0,
		PARTIAL = 1,
		NONE = 2,
		OPAQUE = 3,
	}
	--TODO ADD MOD SUPPORT TILES CATEGORY
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
	--TODO ADD MOD SUPPORT TILES CATEGORY
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
--TODO ADD MOD SUPPORT TILES CATEGORY
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
	--TODO ADD MOD SUPPORT TILES CATEGORY
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
--TODO ADD MOD SUPPORT TILES CATEGORY
function TileLightable(n)
	_JPROFILER.push("TileLightable")
	local t = TileTransparency(n)
	_JPROFILER.pop("TileLightable")
	return t == TilesTransparency.FULL or t == TilesTransparency.NONE
end
--TODO ADD MOD SUPPORT TILES CATEGORY
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
	--TODO ADD MOD SUPPORT TILES CATEGORY
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
	--TODO ADD MOD SUPPORT TILES CATEGORY
	_JPROFILER.push("Tile2D")
	if tile2DCache[n] then
		return tile2DCache[n]
	end
	local result = n == Tiles.YELLO_FLOWER_Block or n == Tiles.ROSE_FLOWER_Block or n == Tiles.OAK_SAPPLING_Block
	tile2DCache[n] = result
	_JPROFILER.pop("Tile2D")
	return result
end
