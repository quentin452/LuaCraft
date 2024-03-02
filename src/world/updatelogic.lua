--TODO FIX : trees sometimes has problems to be generated across chunk borders
--TODO FIX : major lags while using high render distance and caused by chunk.slices[i]:updateModel() and many other

ChunkSet = {}
ChunkHashTable = {}
CaveList = {}
ChunkRequests = {}
LightingQueue = {}
LightingRemovalQueue = {}
ThingList = {}
local previousRenderDistance = nil
local updateCounterForRemeshModel = 0
RenderDistance = getRenderDistanceValue()
function isChunkLoaded(chunkX, chunkZ)
	return ChunkHashTable[ChunkHash(chunkX)] and ChunkHashTable[ChunkHash(chunkX)][ChunkHash(chunkZ)]
end
--how to call isChunkLoaded
--local gx, gy, gz = (self.x - 1) * ChunkSize + i, height, (self.z - 1) * ChunkSize + j
--local chunkX, chunkZ = math.floor(gx / ChunkSize), math.floor(gz / ChunkSize)
--if isChunkLoaded(chunkX, chunkZ) then
--end

function UpdateGame(dt)
	_JPROFILER.push("UpdateGameDT")
	if gamestate == gamestatePlayingGame then
		PlayerInitIfNeeded()
		UpdateAndGenerateChunks(RenderDistance)
		UpdateLogic(dt)
		renderdistancevalue()
	end
	_JPROFILER.pop("UpdateGameDT")
end

function renderdistancevalue()
	_JPROFILER.push("renderdistancevalue")
	if renderdistancegetresetted == true then
		RenderDistance = getRenderDistanceValue()
		for _, chunk in ipairs(renderChunks) do
			destroyChunkModel(chunk)
			updateAllChunksModel()
		end
		renderdistancegetresetted = false
	end
	_JPROFILER.pop("renderdistancevalue")
end

function PlayerInitIfNeeded()
	_JPROFILER.push("PlayerInitIfNeeded")
	if ThePlayer == nil then
		PlayerInit()
	end
	_JPROFILER.pop("PlayerInitIfNeeded")
end

function UpdateAndGenerateChunks(RenderDistance)
	_JPROFILER.push("UpdateAndGenerateChunks")
	renderChunks = {}

	local playerX, playerY, playerZ = ThePlayer.x, ThePlayer.y, ThePlayer.z
	local playerChunkX = math.ceil(playerX / ChunkSize)
	local playerChunkZ = math.ceil(playerZ / ChunkSize)

	UpdateChunksWithinRenderDistance(playerChunkX, playerChunkZ, RenderDistance)
	_JPROFILER.pop("UpdateAndGenerateChunks")
end

function UpdateLogic(dt)
	_JPROFILER.push("UpdateLogic")
	LogicAccumulator = LogicAccumulator + dt
	updateThingList(dt)
	_JPROFILER.pop("UpdateLogic")
end

function UpdateChunksWithinRenderDistance(playerChunkX, playerChunkZ, RenderDistance)
	_JPROFILER.push("UpdateChunksWithinRenderDistance")
	for distance = 0, RenderDistance / ChunkSize do
		for i = -distance, distance do
			for j = -distance, distance do
				local chunkX = playerChunkX + i
				local chunkZ = playerChunkZ + j

				local chunk = GetOrCreateChunk(chunkX, chunkZ)

				if distance < RenderDistance / ChunkSize then
					processChunkUpdates(chunk)
				else
					removeChunksOutsideRenderDistance(chunk, chunkX, chunkZ, playerChunkX, playerChunkZ, RenderDistance)
				end
			end
		end
	end
	_JPROFILER.pop("UpdateChunksWithinRenderDistance")
end

function GetOrCreateChunk(chunkX, chunkZ)
	_JPROFILER.push("GetOrCreateChunk")
	local chunk = ChunkHashTable[ChunkHash(chunkX)] and ChunkHashTable[ChunkHash(chunkX)][ChunkHash(chunkZ)]
	if not chunk then
		chunk = NewChunk(chunkX, chunkZ)
		ChunkSet[chunk] = true
		ChunkHashTable[ChunkHash(chunkX)] = ChunkHashTable[ChunkHash(chunkX)] or {}
		ChunkHashTable[ChunkHash(chunkX)][ChunkHash(chunkZ)] = chunk
	end
	_JPROFILER.pop("GetOrCreateChunk")
	return chunk
end

function removeChunksOutsideRenderDistance(chunk, chunkX, chunkZ, playerChunkX, playerChunkZ, RenderDistance)
	_JPROFILER.push("removeChunksOutsideRenderDistance")
	local chunkDistanceX = math.abs(chunk.x - playerChunkX)
	local chunkDistanceZ = math.abs(chunk.z - playerChunkZ)
	local chunkDistance = math.sqrt(chunkDistanceX ^ 2 + chunkDistanceZ ^ 2)
	if chunkDistance > RenderDistance / ChunkSize then
		local key = ChunkHash(chunkX) .. ":" .. ChunkHash(chunkZ)
		coordCache[key] = nil
		destroyChunkModel(chunk)
	end
	_JPROFILER.pop("removeChunksOutsideRenderDistance")
end

function destroyChunkModel(chunk)
	for i = 1, #chunk.slices do
		local chunkSlice = chunk.slices[i]
		chunkSlice:destroy()
		chunkSlice:destroyModel()
		chunkSlice.enableBlockAndTilesModels = false
		chunk.slices[i] = nil
	end
end

function processChunkUpdates(chunk)
	_JPROFILER.push("processChunkUpdates")
	if chunk.updatedSunLight == false then
		updateSunlight(chunk)
		chunk.updatedSunLight = true
	elseif chunk.isPopulated == false then
		populateChunk(chunk)
		chunk.isPopulated = true
	elseif ThePlayer.IsPlayerHasSpawned == false then
		spawnPlayer()
		ThePlayer.IsPlayerHasSpawned = true
	elseif chunk.updatemodel == false then
		updateChunkModel(chunk)
		chunk.updatemodel = true
	else
		addChunkToRenderQueue(chunk)
		forceModelUpdatesForChunks(chunk)
		processRenderChunks()
	end
	LightingUpdate()
	_JPROFILER.pop("processChunkUpdates")
end

function updateSunlight(chunk)
	_JPROFILER.push("updateSunlight")
	chunk:sunlight()
	_JPROFILER.pop("updateSunlight")
end

function populateChunk(chunk)
	_JPROFILER.push("populateChunk")
	UpdateCaves()
	chunk:populate()
	chunk:processRequests()
	_JPROFILER.pop("populateChunk")
end

function spawnPlayer()
	_JPROFILER.push("spawnPlayer")
	ChooseSpawnLocation()
	_JPROFILER.pop("spawnPlayer")
end

function updateChunkModel(chunk)
	_JPROFILER.push("updateChunkModel")
	chunk:updateModel()
	_JPROFILER.pop("updateChunkModel")
end

function addChunkToRenderQueue(chunk)
	_JPROFILER.push("addChunkToRenderQueue")
	if not isInTable(renderChunks, chunk) then
		table.insert(renderChunks, chunk)
	end
	_JPROFILER.pop("addChunkToRenderQueue")
end

function forceModelUpdatesForChunks(chunk)
	_JPROFILER.push("forceModelUpdatesForChunks")
	updateCounterForRemeshModel = updateCounterForRemeshModel + 1
	--this is to force model updates for chunks : need to be optimized
	if updateCounterForRemeshModel > 1500 then
		for i = 1, WorldHeight / SliceHeight do
			if chunk.slices[i] and not chunk.slices[i].isUpdating then
				chunk.slices[i]:updateModel()
			end
			updateCounterForRemeshModel = 0
		end
	end
	_JPROFILER.pop("forceModelUpdatesForChunks")
end

function processRenderChunks()
	_JPROFILER.push("processRenderChunks")
	for _, chunk in ipairs(renderChunks) do
		for _ = 1, WorldHeight / SliceHeight do
			if not chunk.slices[_] then
				chunk.slices[_] = NewChunkSlice(chunk.x, chunk.y + (_ - 1) * SliceHeight + 1, chunk.z, chunk)
			end
		end
		for i = 1, #chunk.slices do
			local chunkSlice = chunk.slices[i]
			chunkSlice.enableBlockAndTilesModels = true
		end
		if #chunk.changes > 0 then
			chunk:updateModel()
		end
	end
	_JPROFILER.pop("processRenderChunks")
end

function isInTable(tbl, value)
	for _, v in ipairs(tbl) do
		if v == value then
			return true
		end
	end
	return false
end

function updateThingList(dt)
	_JPROFILER.push("updateThingList")

	local i = 1

	while i <= #ThingList do
		local thing = ThingList[i]

		if thing:update(dt) then
			i = i + 1
		else
			table.remove(ThingList, i)
			thing:destroy()
			thing:destroyModel()
		end
	end
	-- update 3D scene with dt only if PhysicsStep is true
	if PhysicsStep then
		Scene:update()
	end

	local logicThreshold = 1 / 60
	local fps = love.timer.getFPS()

	if LogicAccumulator >= logicThreshold and fps ~= 0 then
		local logicUpdates = math.floor(LogicAccumulator / logicThreshold)
		LogicAccumulator = LogicAccumulator - logicThreshold * logicUpdates
		PhysicsStep = true
	else
		PhysicsStep = false
	end
	_JPROFILER.pop("updateThingList")
end
