local getChunkCounter = 0

local function GetChunkDebug(x, y, z)
	local startTime = os.clock()
	local x, y, z = math.floor(x), math.floor(y), math.floor(z)
	local hashStart = os.clock()
	local hashx, hashy = ChunkHash(math.floor(x / ChunkSize) + 1), ChunkHash(math.floor(z / ChunkSize) + 1)
	local hashTime = os.clock() - hashStart

	local getStart = os.clock()
	local getChunk = nil
	if ChunkHashTable[hashx] ~= nil then
		getChunk = ChunkHashTable[hashx][hashy]
	end
	local getTime = os.clock() - getStart

	if y < 1 or y > WorldHeight then
		getChunk = nil
	end

	local mx, mz = x % ChunkSize + 1, z % ChunkSize + 1

	local endTime = os.clock() - startTime

	if getChunkCounter < 1000 then
		ThreadLogChannel:push({
			LuaCraftLoggingLevel.NORMAL,
			"GetChunk timings:",
		})
		ThreadLogChannel:push({
			LuaCraftLoggingLevel.NORMAL,
			"Hash:" .. hashTime,
		})
		ThreadLogChannel:push({
			LuaCraftLoggingLevel.NORMAL,
			"Get from hash:" .. getTime,
		})
		ThreadLogChannel:push({
			LuaCraftLoggingLevel.NORMAL,
			"Total:" .. endTime,
		})
		getChunkCounter = getChunkCounter + 1
	end
	return getChunk, mx, y, mz, hashx, hashy
end

function LightningQueriesTestUnit(x, y, z, lightoperation, value)
	local startTime = love.timer.getTime()
	local cget, cx, cy, cz = GetChunkDebug(x, y, z)
	local chunkTime = love.timer.getTime() - startTime

	local chunkStatus = "Chunk retrieved"
	if cget == nil then
		chunkStatus = "Failed to retrieve chunk"
		return
	end
	if LightningQueriesTestUnitOperationCounter[lightoperation] <= 1000 then
		ThreadLogChannel:push({
			LuaCraftLoggingLevel.NORMAL,
			chunkStatus .. " - Chunk time: " .. chunkTime .. " seconds",
		})
	end
	local query = function()
		local startTime2 = love.timer.getTime()
		PerformLightOperation(cget, cx, cy, cz, lightoperation, value, x, y, z)
		local queryTime = love.timer.getTime() - startTime2
		if LightningQueriesTestUnitOperationCounter[lightoperation] <= 1000 then
			ThreadLogChannel:push({
				LuaCraftLoggingLevel.NORMAL,
				lightoperation .. " query time: " .. queryTime .. " seconds",
			})
			LightningQueriesTestUnitOperationCounter[lightoperation] = LightningQueriesTestUnitOperationCounter[lightoperation]
				+ 1
			ThreadLogChannel:push({
				LuaCraftLoggingLevel.NORMAL,
				lightoperation .. " counter: " .. LightningQueriesTestUnitOperationCounter[lightoperation],
			})
		end
	end
	return query
end

function NewLightOperationTestUnit( query, lightoperation)
	local startTime = love.timer.getTime()
	ChooseLightingQueue(lightoperation, query)
	local endTime = love.timer.getTime() - startTime
	LightningQueriesTestUnitOperationCounter[lightoperation] = (
		LightningQueriesTestUnitOperationCounter[lightoperation] or 0
	) + 1
	if LightningQueriesTestUnitOperationCounter[lightoperation] <= 1000 then
		ThreadLogChannel:push({
			LuaCraftLoggingLevel.NORMAL,
			lightoperation .. " operation time: " .. endTime .. " seconds",
		})
	end
end
