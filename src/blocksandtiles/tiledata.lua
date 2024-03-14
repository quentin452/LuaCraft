local transparencyCache = {}
local lightSourceCache = {}
local collisionCache = {}
TileMode = {
	BlockMode = "3DBlock",
	TileMode = "2DTile",
	LiquidMode = "3DLiquidBlock",
	None = "None",
}

CollideMode = {
	YesCanCollide = "YesCanCollide",
	NoCannotCollide = "NoCannotCollide",
}

TilesTransparency = {
	FULL = 0,
	PARTIAL = 1,
	NONE = 2,
	OPAQUE = 3,
}

LightSources = {}

for i = 0, 15 do
	LightSources[i] = i
end

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

function InitializeTilesNumberAndName()
	if next(Tiles, next(Tiles)) ~= nil then
		LuaCraftErrorLogging("Error: Tiles table must only contain AIR_Block before calling addBlock")
	end
	for _, func in ipairs(ModLoaderTable["addBlock"]) do
		func()
	end
end
function GetValueFromTilesById(n)
	return TilesById[n]
end

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

function TileLightable(n, includePartial)
	local t = TileTransparency(n)
	return (t == TilesTransparency.FULL or t == TilesTransparency.NONE)
		or (includePartial and t == TilesTransparency.PARTIAL)
end

function TileTextures(n)
	return TilesTextureList[n]
end

function TileModel(n)
	if n ~= 0 then
		local tileData = GetValueFromTilesById(n)
		if tileData and tileData.BlockOrLiquidOrTile == TileMode.TileMode then
			return 1
		end
	end
	return 0
end

function Tile2DHUD(n)
	local tileData = GetValueFromTilesById(n)
	return tileData and tileData.BlockOrLiquidOrTile == TileMode.TileMode
end
