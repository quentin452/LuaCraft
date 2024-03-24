-- Import LuaTest framework
local luaunit = require("luaunit")
local import = require("libs/penlight/import_into")
import(_G)
-- Nombre de tuiles à générer
local TILE_COUNT = 1000000

-- Liste des types de tuiles disponibles
local tileTypes = { "stone", "dirt", "grass" }

-- Tables pour stocker les données
local Tiles = Set()
local TilesById = Set()

-- Génération aléatoire
for id = 1, TILE_COUNT do
	-- Choix aléatoire du type de tuile
	local randomType = tileTypes[math.random(#tileTypes)]

	-- Création de l'entrée dans Tiles
	Tiles[id] = {
		blockstringname = randomType,
		transparency = math.random(),
		lightSource = math.random(15),
		-- Ajout d'une propriété pour la collision
		Cancollide = math.random(2) == 1, -- Random true/false value
	}

	-- Ajout dans TilesById
	TilesById[id] = Tiles[id]
end

-- Function to test GetTileProperty with caching
function testGetTilePropertyWithCache()
	-- Set up cache table
	local tilePropertyCache = {}

	-- Mock GetValueFromTilesById function
	local function MockGetValueFromTilesById(n)
		return TilesById[n]
	end

	-- Mock CollideMode
	local CollideMode = { YesCanCollide = true }

	-- Mock GetTileProperty with caching
	local function MockGetTilePropertyWithCache(n, property)
		if not tilePropertyCache[n] then
			tilePropertyCache[n] = {}
		end

		if not tilePropertyCache[n][property] then
			local value = MockGetValueFromTilesById(n)
			if value then
				local propertyValue
				if property == "collision" then
					propertyValue = value.Cancollide == CollideMode.YesCanCollide
				elseif property == "transparency" then
					propertyValue = Tiles[n].transparency
				elseif property == "lightsource" then
					propertyValue = Tiles[n].lightSource
				end
				tilePropertyCache[n][property] = propertyValue
			end
		end

		return tilePropertyCache[n][property]
	end

	-- Capture start time
	local startTime = os.clock()

	-- Test properties for all tiles to fill the cache
	for id = 1, TILE_COUNT do
		luaunit.assertEquals(MockGetTilePropertyWithCache(id, "collision"), Tiles[id].Cancollide)
		luaunit.assertEquals(MockGetTilePropertyWithCache(id, "transparency"), Tiles[id].transparency)
		luaunit.assertEquals(MockGetTilePropertyWithCache(id, "lightsource"), Tiles[id].lightSource)
	end

	-- Capture end time after filling the cache
	local endTimeFill = os.clock()

	-- Calculate elapsed time after filling the cache
	local elapsedTimeFill = endTimeFill - startTime

	-- Log the elapsed time after filling the cache
	print("Elapsed time to fill cache:", elapsedTimeFill, "seconds")

	-- Capture start time for second loop
	local startTimeAccess = os.clock()

	-- Test properties for all tiles again to access with cache
	for id = 1, TILE_COUNT do
		luaunit.assertEquals(MockGetTilePropertyWithCache(id, "collision"), Tiles[id].Cancollide)
		luaunit.assertEquals(MockGetTilePropertyWithCache(id, "transparency"), Tiles[id].transparency)
		luaunit.assertEquals(MockGetTilePropertyWithCache(id, "lightsource"), Tiles[id].lightSource)
	end

	-- Capture end time for second loop
	local endTimeAccess = os.clock()

	-- Calculate elapsed time for second loop
	local elapsedTimeAccess = endTimeAccess - startTimeAccess

	-- Log the elapsed time for second loop
	print("Elapsed time with cache:", elapsedTimeAccess, "seconds")

	-- Capture start time for second loop
	local startTimeSecond = os.clock()

	-- Test properties for all tiles second time
	for id = 1, TILE_COUNT do
		luaunit.assertEquals(MockGetTilePropertyWithCache(id, "collision"), Tiles[id].Cancollide)
		luaunit.assertEquals(MockGetTilePropertyWithCache(id, "transparency"), Tiles[id].transparency)
		luaunit.assertEquals(MockGetTilePropertyWithCache(id, "lightsource"), Tiles[id].lightSource)
	end

	-- Capture end time for second loop
	local endTimeSecond = os.clock()

	-- Calculate elapsed time for second loop
	local elapsedTimeSecond = endTimeSecond - startTimeSecond

	-- Log the elapsed time for second loop
	print("Elapsed time with cache (third loop):", elapsedTimeSecond, "seconds")
end

luaunit.run()
