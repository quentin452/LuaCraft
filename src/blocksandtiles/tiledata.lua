Tiles = {
	AIR_Block = 0,
}
TilesTransparency = {
	FULL = 0,
	PARTIAL = 1,
	NONE = 2,
	OPAQUE = 3,
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

function InitializeTilesNumberAndName()
	LuaCraftPrintLoggingNormal("Initializing tiles...")
	for _, func in ipairs(ModLoaderTable["addBlock"]) do
		func()
	end
	TilesString = {}
	for key, _ in pairs(Tiles) do
		TilesString[key] = key
	end
	transparencyLookup = {
		[Tiles.AIR_Block] = TilesTransparency.FULL,
	}

	for _, func in ipairs(ModLoaderTable["addTransparencyLookup"]) do
		func()
	end
	lightSourceLookup = {
		[Tiles.AIR_Block] = LightSources[0],
	}
	for _, func in ipairs(ModLoaderTable["addLightSourceLookup"]) do
		func()
	end
	nonCollidableTiles = {
		[Tiles.AIR_Block] = true,
	}
	for _, func in ipairs(ModLoaderTable["madeThisTileNonCollidable"]) do
		func()
	end
	Tile2DHUDTable = {}
	for _, func in ipairs(ModLoaderTable["madeTile2DRenderedOnHUD"]) do
		func()
	end

	TileModelTable = {}
	for _, func in ipairs(ModLoaderTable["transform3DBlockToA2DTile"]) do
		func()
	end

	for key, value in pairs(Tiles) do
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
	LuaCraftPrintLoggingNormal("Tiles initialized!")
end
function TileCollisions(n)
	_JPROFILER.push("TileCollisions")

	if nonCollidableTiles[n] then
		_JPROFILER.pop("TileCollisions")
		return false
	end

	_JPROFILER.pop("TileCollisions")
	return true
end

function getTileName(n)
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
	if transparencyLookup[n] == nil then
		error("Key not found in transparencyLookup: " .. getTileName(n))
	end
	_JPROFILER.push("TileTransparency")
	local transparency = transparencyLookup[n]
	_JPROFILER.pop("TileTransparency")
	return transparency
end

function TileLightSource(n)
	if lightSourceLookup[n] == nil then
		error("Key not found in lightSourceLookup: " .. getTileName(n))
	end
	_JPROFILER.push("TileLightSource")
	local result = lightSourceLookup[n]
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
	if TilesTextureList[n] == nil then
		error("Key not found in TilesTextureList: " .. getTileName(n))
	end
	return TilesTextureList[n]
end
function TileTexturesFORHUD(n)
	if TilesTextureListHUD[n] == nil then
		error("Key not found in TilesTextureListHUD: " .. getTileName(n))
	end
	return TilesTextureListHUD[n]
end
function TileModel(n)
	local result = 0
	for k, v in pairs(TileModelTable) do
		if k == n then
			result = v
			break
		end
	end
	return result
end

function Tile2DHUD(n)
	local result = false
	for k, v in pairs(Tile2DHUDTable) do
		if k == n then
			result = v
			break
		end
	end
	return result
end
