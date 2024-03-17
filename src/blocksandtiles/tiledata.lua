-- Initializes the tiles table with default values
function InitializeTilesNumberAndName()
	if next(Tiles, next(Tiles)) ~= nil then
		ThreadLogChannel:push({
			LuaCraftLoggingLevel.ERROR,
			"Tiles table must only contain AIR_Block before calling addBlock",
		})
	end
	for _, taggedFunc in ipairs(ModLoaderTable["addBlock"]) do
		taggedFunc.func()
	end
end

-- Retrieves tile data from Tiles table by ID
function GetValueFromTilesById(n)
	return TilesById[n]
end

-- Retrieves collision property of a tile by ID
function TileCollisions(n)
	if TileCollisionCache[n] ~= nil then
		return TileCollisionCache[n]
	end
	local value = GetValueFromTilesById(n)
	if value then
		local collision = value.Cancollide == CollideMode.YesCanCollide
		TileCollisionCache[n] = collision
		return collision
	end
	return false
end

-- Retrieves transparency level of a tile by ID
function TileTransparency(n)
	if TileTransparencyCache[n] ~= nil then
		return TileTransparencyCache[n]
	end
	local value = GetValueFromTilesById(n)
	if value then
		local blockstringname = value.blockstringname
		local transparency = Tiles[blockstringname].transparency
		TileTransparencyCache[n] = transparency
		return transparency
	end
end

-- Retrieves light source value of a tile by ID
function TileLightSource(n)
	if TileLightSourceCache[n] ~= nil then
		return TileLightSourceCache[n]
	end
	local value = GetValueFromTilesById(n)
	if value then
		local blockstringname = value.blockstringname
		local lightSource = Tiles[blockstringname].LightSources
		TileLightSourceCache[n] = lightSource
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
