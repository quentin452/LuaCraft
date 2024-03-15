-- Caches for tile transparency, light sources, and collision properties
local transparencyCache = {}
local lightSourceCache = {}
local collisionCache = {}

-- Enumeration for tile modes
TileMode = {
	BlockMode = "3DBlock",
	TileMode = "2DTile",
	LiquidMode = "3DLiquidBlock",
	None = "None",
}

-- Enumeration for collision modes
CollideMode = {
	YesCanCollide = "YesCanCollide",
	NoCannotCollide = "NoCannotCollide",
}

-- Enumeration for tile transparency levels
TilesTransparency = {
	FULL = 0,
	PARTIAL = 1,
	NONE = 2,
	OPAQUE = 3,
}

-- Array to store light source values
LightSources = {}

for i = 0, 15 do
	LightSources[i] = i
end

-- Table to store tile data
Tiles = {
	AIR_Block = {
		id = 0,
		blockstringname = "AIR_Block",
		transparency = TilesTransparency.FULL,
		LightSources = LightSources[0],
		Cancollide = CollideMode.NoCannotCollide,
		BlockOrLiquidOrTile = TileMode.BlockMode,
	},
}

-- Initializes the tiles table with default values
function InitializeTilesNumberAndName()
	if next(Tiles, next(Tiles)) ~= nil then
		LuaCraftErrorLogging("Error: Tiles table must only contain AIR_Block before calling addBlock")
	end
	for _, func in ipairs(ModLoaderTable["addBlock"]) do
		func()
	end
end

-- Retrieves tile data from Tiles table by ID
function GetValueFromTilesById(n)
	return TilesById[n]
end

-- Retrieves collision property of a tile by ID
function TileCollisions(n)
	if collisionCache[n] ~= nil then
		return collisionCache[n]
	end
	local value = GetValueFromTilesById(n)
	if value then
		local collision = value.Cancollide == CollideMode.YesCanCollide
		collisionCache[n] = collision
		return collision
	end
	return false
end

-- Retrieves transparency level of a tile by ID
function TileTransparency(n)
	if transparencyCache[n] ~= nil then
		return transparencyCache[n]
	end
	local value = GetValueFromTilesById(n)
	if value then
		local blockstringname = value.blockstringname
		local transparency = Tiles[blockstringname].transparency
		transparencyCache[n] = transparency
		return transparency
	end
end

-- Retrieves light source value of a tile by ID
function TileLightSource(n)
	if lightSourceCache[n] ~= nil then
		return lightSourceCache[n]
	end
	local value = GetValueFromTilesById(n)
	if value then
		local blockstringname = value.blockstringname
		local lightSource = Tiles[blockstringname].LightSources
		lightSourceCache[n] = lightSource
		return lightSource
	end
end

-- Checks if a tile can emit light
function TileLightable(n, includePartial)
	local t = TileTransparency(n)
	return (t == TilesTransparency.FULL or t == TilesTransparency.NONE)
		or (includePartial and t == TilesTransparency.PARTIAL)
end

-- Retrieves textures associated with a tile
function TileTextures(n)
	return TilesTextureList[n]
end

-- Retrieves model type of a tile (2D or 3D)
function TileModel(n)
	if n ~= 0 then
		local tileData = GetValueFromTilesById(n)
		if tileData and tileData.BlockOrLiquidOrTile == TileMode.TileMode then
			return 1
		end
	end
	return 0
end

-- Checks if a tile is intended for 2D HUD display
function Tile2DHUD(n)
	local tileData = GetValueFromTilesById(n)
	return tileData and tileData.BlockOrLiquidOrTile == TileMode.TileMode
end
