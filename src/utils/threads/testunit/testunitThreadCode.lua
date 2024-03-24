TestUnitThreadChannel, ThreadLogChannel, LuaCraftLoggingLevel, EnableTestUnitWaitingScreen,EnableTestUnitWaitingScreenChannel = ...

local TILE_COUNT = 10000000
local tileTypes = { "stone", "dirt", "grass" }
function TestUnitTileDataWithCache2()
	local Tiles = {}
	local TilesById = {}
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
		"Elapsed time to fill cache: " .. elapsedTimeFill,
		"seconds",
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
		"Elapsed time with cache: " .. elapsedTimeAccess,
		"seconds",
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
		"Elapsed time with cache (third loop): " .. elapsedTimeSecond,
		"seconds",
	})
	TilesById = nil
	Tiles = nil
	tilePropertyCache = nil
end

function TestUnitTileDataWithoutCache2()
	local Tiles = {}
	local TilesById = {}
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
		"Elapsed time without cache (first loop): " .. elapsedTimeFirst,
		"seconds",
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
		"Elapsed time without cache (second loop): " .. elapsedTimeSecond,
		"seconds",
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
		"Elapsed time without cache (third loop): " .. elapsedTimeSecond,
		"seconds",
	})
	TilesById = nil
	Tiles = nil
end

while true do
	local message = TestUnitThreadChannel:demand()
	if message then
		local level = unpack(message)
		if level == "TestUnitTileDataWithCache2" then
			TestUnitTileDataWithCache2()
			--EnableTestUnitWaitingScreen = false
			EnableTestUnitWaitingScreenChannel:push(true)
		elseif level == "TestUnitTileDataWithoutCache2" then
			TestUnitTileDataWithoutCache2()
			--EnableTestUnitWaitingScreen = false
			EnableTestUnitWaitingScreenChannel:push(true)
		end
	end
end
