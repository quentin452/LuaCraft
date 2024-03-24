local TILE_COUNT = 10000000
local tileTypes = { "stone", "dirt", "grass" }
local Tiles = Set()
local TilesById = Set()
function TestUnitTileDataWithoutCache2()
	for id = 1, TILE_COUNT do
		local randomType = tileTypes[math.random(#tileTypes)]
		Tiles[id] = {
			blockstringname = randomType,
			transparency = math.random(),
			lightSource = math.random(15),
			Cancollide = math.random(2) == 1,
		}
		TilesById[id] = Tiles[id]
	end
	local function MockGetValueFromTilesById(n)
		return TilesById[n]
	end
	local CollideMode = { YesCanCollide = true }
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
	local startTime = os.clock()
	for id = 1, TILE_COUNT do
		MockGetTilePropertyWithoutCache(id, "collision")
		MockGetTilePropertyWithoutCache(id, "transparency")
		MockGetTilePropertyWithoutCache(id, "lightsource")
	end
	local endTimeFirst = os.clock()
	local elapsedTimeFirst = endTimeFirst - startTime
	ThreadLogChannel:push({
		LuaCraftLoggingLevel.NORMAL,
		"Elapsed time without cache (first loop): " .. elapsedTimeFirst, "seconds"
	})
	local startTimeSecond = os.clock()
	for id = 1, TILE_COUNT do
		MockGetTilePropertyWithoutCache(id, "collision")
		MockGetTilePropertyWithoutCache(id, "transparency")
		MockGetTilePropertyWithoutCache(id, "lightsource")
	end
	local endTimeSecond = os.clock()
	local elapsedTimeSecond = endTimeSecond - startTimeSecond
	ThreadLogChannel:push({
		LuaCraftLoggingLevel.NORMAL,
		"Elapsed time without cache (second loop): " .. elapsedTimeSecond, "seconds"
	})
	local startTimeSecond = os.clock()
	for id = 1, TILE_COUNT do
		MockGetTilePropertyWithoutCache(id, "collision")
		MockGetTilePropertyWithoutCache(id, "transparency")
		MockGetTilePropertyWithoutCache(id, "lightsource")
	end
	local endTimeSecond = os.clock()
	local elapsedTimeSecond = endTimeSecond - startTimeSecond
	ThreadLogChannel:push({
		LuaCraftLoggingLevel.NORMAL,
		"Elapsed time without cache (third loop): " .. elapsedTimeSecond, "seconds"
	})
end
