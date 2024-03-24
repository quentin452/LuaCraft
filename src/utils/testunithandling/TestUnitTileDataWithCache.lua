local TILE_COUNT = 10000000
local tileTypes = { "stone", "dirt", "grass" }
local Tiles = Set()
local TilesById = Set()
function TestUnitTileDataWithCache2()
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
	local tilePropertyCache = {}
	local function MockGetValueFromTilesById(n)
		return TilesById[n]
	end
	local CollideMode = { YesCanCollide = true }
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
	local startTime = os.clock()
	for id = 1, TILE_COUNT do
		MockGetTilePropertyWithCache(id, "collision")
		MockGetTilePropertyWithCache(id, "transparency")
		MockGetTilePropertyWithCache(id, "lightsource")
	end
	local endTimeFill = os.clock()
	local elapsedTimeFill = endTimeFill - startTime
	ThreadLogChannel:push({
		LuaCraftLoggingLevel.NORMAL,
		"Elapsed time to fill cache: " .. elapsedTimeFill, "seconds"
	})
	local startTimeAccess = os.clock()
		for id = 1, TILE_COUNT do
		MockGetTilePropertyWithCache(id, "collision")
		MockGetTilePropertyWithCache(id, "transparency")
		MockGetTilePropertyWithCache(id, "lightsource")
	end
	local endTimeAccess = os.clock()
	local elapsedTimeAccess = endTimeAccess - startTimeAccess
	ThreadLogChannel:push({
		LuaCraftLoggingLevel.NORMAL,
		"Elapsed time with cache: " .. elapsedTimeAccess, "seconds"
	})
	local startTimeSecond = os.clock()
	for id = 1, TILE_COUNT do
		MockGetTilePropertyWithCache(id, "collision")
		MockGetTilePropertyWithCache(id, "transparency")
		MockGetTilePropertyWithCache(id, "lightsource")
	end
	local endTimeSecond = os.clock()
	local elapsedTimeSecond = endTimeSecond - startTimeSecond
	ThreadLogChannel:push({
		LuaCraftLoggingLevel.NORMAL,
		"Elapsed time with cache (third loop): " .. elapsedTimeSecond, "seconds"
	})
end
