-- Import LuaTest framework
local luaunit = require("luaunit")
local import = require("penlight/import_into")
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

-- Function to test GetTileProperty without caching
function testGetTilePropertyWithoutCache()
	-- Mock GetValueFromTilesById function
	local function MockGetValueFromTilesById(n)
		return TilesById[n]
	end

	-- Mock CollideMode
	local CollideMode = { YesCanCollide = true }

	-- Mock GetTileProperty without caching
	local function MockGetTilePropertyWithoutCache(n, property)
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
			return propertyValue
		end
	end

	-- Capture start time for first loop
	local startTime = os.clock()

	-- Test properties for all tiles first time
	for id = 1, TILE_COUNT do
		luaunit.assertEquals(MockGetTilePropertyWithoutCache(id, "collision"), Tiles[id].Cancollide)
		luaunit.assertEquals(MockGetTilePropertyWithoutCache(id, "transparency"), Tiles[id].transparency)
		luaunit.assertEquals(MockGetTilePropertyWithoutCache(id, "lightsource"), Tiles[id].lightSource)
	end

	-- Capture end time for first loop
	local endTimeFirst = os.clock()

	-- Calculate elapsed time for first loop
	local elapsedTimeFirst = endTimeFirst - startTime

	-- Log the elapsed time for first loop
	print("Elapsed time without cache (first loop):", elapsedTimeFirst, "seconds")

	-- Capture start time for second loop
	local startTimeSecond = os.clock()

	-- Test properties for all tiles second time
	for id = 1, TILE_COUNT do
		luaunit.assertEquals(MockGetTilePropertyWithoutCache(id, "collision"), Tiles[id].Cancollide)
		luaunit.assertEquals(MockGetTilePropertyWithoutCache(id, "transparency"), Tiles[id].transparency)
		luaunit.assertEquals(MockGetTilePropertyWithoutCache(id, "lightsource"), Tiles[id].lightSource)
	end

	-- Capture end time for second loop
	local endTimeSecond = os.clock()

	-- Calculate elapsed time for second loop
	local elapsedTimeSecond = endTimeSecond - startTimeSecond

	-- Log the elapsed time for second loop
	print("Elapsed time without cache (second loop):", elapsedTimeSecond, "seconds")

	-- Capture start time for second loop
	local startTimeSecond = os.clock()

	-- Test properties for all tiles second time
	for id = 1, TILE_COUNT do
		luaunit.assertEquals(MockGetTilePropertyWithoutCache(id, "collision"), Tiles[id].Cancollide)
		luaunit.assertEquals(MockGetTilePropertyWithoutCache(id, "transparency"), Tiles[id].transparency)
		luaunit.assertEquals(MockGetTilePropertyWithoutCache(id, "lightsource"), Tiles[id].lightSource)
	end

	-- Capture end time for second loop
	local endTimeSecond = os.clock()

	-- Calculate elapsed time for second loop
	local elapsedTimeSecond = endTimeSecond - startTimeSecond

	-- Log the elapsed time for second loop
	print("Elapsed time without cache (third loop):", elapsedTimeSecond, "seconds")
end

luaunit.run()
