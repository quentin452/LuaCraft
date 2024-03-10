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
	LuaCraftPrintLoggingNormal("Initializing tiles...")
	if next(Tiles, next(Tiles)) ~= nil then
		error("Error: Tiles table must only contain AIR_Block before calling addBlock")
	end
	for _, func in ipairs(ModLoaderTable["addBlock"]) do
		func()
	end

	for _, value in pairs(Tiles) do
		LuaCraftPrintLoggingNormal(
			"Tile Name: "
				.. value.blockstringname
				.. " Tile Index: "
				.. value.id
				.. " Tile Transparency: "
				.. value.transparency
				.. " Tile Light Source: "
				.. value.LightSources
				.. "\n-----------------------------------------------------------------------------------------------------------------------"
		)
	end

	LuaCraftPrintLoggingNormal("Tiles initialized!")
end
function TileCollisions(n)
	local value = TilesById[n]
	if value then
		return value.Cancollide == CollideMode.YesCanCollide
	end
	return false
end
function TileTransparency(n)
	local value = TilesById[n]
	if value then
		local blockstringname = value.blockstringname
		return Tiles[blockstringname].transparency
	end
end

function TileLightSource(n)
	local value = TilesById[n]
	if value then
		local blockstringname = value.blockstringname
		return Tiles[blockstringname].LightSources
	end
end

function TileLightable(n)
	local t = TileTransparency(n)
	return t == TilesTransparency.FULL or t == TilesTransparency.NONE
end

function TileSemiLightable(n)
	local t = TileTransparency(n)
	return t == TilesTransparency.FULL or t == TilesTransparency.PARTIAL or t == TilesTransparency.NONE
end

function TileTextures(n)
	return TilesTextureList[n]
end

function TileTexturesFORHUD(n)
	return TilesTextureListHUD[n]
end

function TileModel(n)
	if n ~= 0 then
		local tileData = TilesById[n]
		if tileData and tileData.BlockOrLiquidOrTile == TileMode.TileMode then
			return 1
		end
	end
	return 0
end

function Tile2DHUD(n)
	local tileData = TilesById[n]
	return tileData and tileData.BlockOrLiquidOrTile == TileMode.TileMode
end

function getTileName(n)
	local tileData = TilesById[n]
	return tileData and tileData.blockname or "Unknown"
end
