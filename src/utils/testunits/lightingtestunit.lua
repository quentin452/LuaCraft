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
		if lightoperation == LightOpe.SunForceAdd.id then
			SunForceAdd(cget, cx, cy, cz, value, x, y, z)
		elseif lightoperation == LightOpe.SunCreationAdd.id then
			SunCreationAdd(cget, cx, cy, cz, x, y, z)
		elseif lightoperation == LightOpe.SunDownAdd.id then
			SunDownAdd(cget, cx, cy, cz, value, x, y, z)
		elseif lightoperation == LightOpe.LocalForceAdd.id then
			LocalForceAdd(cget, cx, cy, cz, value, x, y, z)
		elseif lightoperation == LightOpe.LocalSubtract.id then
			LocalSubtract(cget, cx, cy, cz, value, x, y, z)
		elseif lightoperation == LightOpe.LocalCreationAdd.id then
			LocalCreationAdd(cget, cx, cy, cz, x, y, z)
		elseif lightoperation == LightOpe.SunAdd.id then
			SunAdd(cget, cx, cy, cz, value, x, y, z)
		elseif lightoperation == LightOpe.LocalAdd.id then
			LocalAdd(cget, value, x, y, z)
		elseif lightoperation == LightOpe.SunSubtract.id then
			SunSubtract(cget, cx, cy, cz, value, x, y, z)
		elseif lightoperation == LightOpe.SunDownSubtract.id then
			SunDownSubtract(x, y, z)
		end
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
