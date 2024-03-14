--TODO FIX : trees sometimes has problems to be generated across chunk borders
--TODO FIX : major lags while using high render distance and caused by chunk.slices[i]:updateModel() and many other

ChunkSet = {}
ChunkHashTable = {}
CaveList = {}
ThingList = {}
local destroyChunkModels = 0
local updateCounterForRemeshModel = 0

RenderDistance = getRenderDistanceValue()

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
	local playerPosition = getPlayerPosition()
	local playerX, playerY, playerZ = playerPosition.x, playerPosition.y, playerPosition.z
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
	local maxChunkDistance = RenderDistance / ChunkSize
	for distance = 0, maxChunkDistance do
		UpdateChunksWithinRenderDistanceDistanceLoop(playerChunkX, playerChunkZ, distance, maxChunkDistance)
	end
	_JPROFILER.pop("UpdateChunksWithinRenderDistance")
end

function UpdateChunksWithinRenderDistanceDistanceLoop(playerChunkX, playerChunkZ, distance, maxChunkDistance)
	_JPROFILER.push("UpdateChunksWithinRenderDistanceDistanceLoop")
	for i = -distance, distance do
		for j = -distance, distance do
			UpdateChunksWithinRenderDistanceChunkLoop(playerChunkX, playerChunkZ, i, j, distance, maxChunkDistance)
		end
	end
	_JPROFILER.pop("UpdateChunksWithinRenderDistanceDistanceLoop")
end

function UpdateChunksWithinRenderDistanceChunkLoop(playerChunkX, playerChunkZ, i, j, distance, maxChunkDistance)
	_JPROFILER.push("UpdateChunksWithinRenderDistanceChunkLoop")
	local chunkX = playerChunkX + i
	local chunkZ = playerChunkZ + j
	local chunk = GetOrCreateChunk(chunkX, chunkZ)
	if distance < maxChunkDistance then
		processChunkUpdates(chunk)
	else
		removeChunksOutsideRenderDistance(playerChunkX, playerChunkZ, RenderDistance)
	end
	_JPROFILER.pop("UpdateChunksWithinRenderDistanceChunkLoop")
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

function removeChunksOutsideRenderDistance(playerChunkX, playerChunkZ, RenderDistance)
	_JPROFILER.push("removeChunksOutsideRenderDistance")
	destroyChunkModels = destroyChunkModels + 1
	if destroyChunkModels > 50000 then
		local maxChunkDistanceSquared = (RenderDistance / ChunkSize) ^ 2

		for otherChunk, _ in pairs(ChunkSet) do
			local otherChunkXCenter = otherChunk.x
			local otherChunkZCenter = otherChunk.z

			local dx = otherChunkXCenter - playerChunkX
			local dz = otherChunkZCenter - playerChunkZ

			local distanceSquared = dx ^ 2 + dz ^ 2

			if distanceSquared > maxChunkDistanceSquared then
				forceChunkModelsRemoval(otherChunk)
			end
		end
		destroyChunkModels = 0
	end
	_JPROFILER.pop("removeChunksOutsideRenderDistance")
end

function forceChunkModelsRemoval(chunk)
	_JPROFILER.push("forceChunkModelsRemoval")
	if chunk.slices then
		for i = 1, #chunk.slices do
			local chunkSlice = chunk.slices[i]
			if chunkSlice and not chunkSlice.isDestroyed then
				chunkSlice:destroy()
				chunkSlice:destroyModel()
				chunk.slices[i] = nil
			end
		end
		chunk.slices = {}
	end
	_JPROFILER.pop("forceChunkModelsRemoval")
end

function processChunkUpdates(chunk)
	_JPROFILER.push("processChunkUpdates")
	if chunk.updatedSunLight == false then
		_JPROFILER.push("updateSunlight")
		chunk:sunlight()
		_JPROFILER.pop("updateSunlight")
		chunk.updatedSunLight = true
	elseif chunk.isPopulated == false then
		_JPROFILER.push("populateChunk")
		chunk:populate()
		UpdateCaves()
		chunk:processRequests()
		_JPROFILER.pop("populateChunk")
		chunk.isPopulated = true
	elseif chunk.updatemodel == false then
		_JPROFILER.push("updateChunkModel")
		chunk:updateModel()
		_JPROFILER.pop("updateChunkModel")
		_JPROFILER.push("LightingUpdate_processChunkUpdates")
		LightingUpdate()
		_JPROFILER.pop("LightingUpdate_processChunkUpdates")
		chunk.updatemodel = true
	elseif ThePlayer.IsPlayerHasSpawned == false then
		_JPROFILER.push("spawnPlayer")
		ChooseSpawnLocation()
		_JPROFILER.pop("spawnPlayer")
	else
		addChunkToRenderQueue(chunk)
		forceModelUpdatesForChunks(chunk)
		processRenderChunks()
	end
	_JPROFILER.pop("processChunkUpdates")
end

function addChunkToRenderQueue(chunk)
	_JPROFILER.push("addChunkToRenderQueue")
	table.insert(renderChunks, chunk)
	_JPROFILER.pop("addChunkToRenderQueue")
end

function forceModelUpdatesForChunks(chunk)
	_JPROFILER.push("forceModelUpdatesForChunks")
	updateCounterForRemeshModel = updateCounterForRemeshModel + 1
	if updateCounterForRemeshModel > 5000 then
		updateSlicesForChunk(chunk)
		updateCounterForRemeshModel = 0
	end
	_JPROFILER.pop("forceModelUpdatesForChunks")
end
function updateSlicesForChunk(chunk)
	_JPROFILER.push("updateSlicesForChunk")
	local sliceIndex = 1
	while sliceIndex <= WorldHeight / SliceHeight do
		local slice = chunk.slices[sliceIndex]
		if slice and not slice.modelneedtobeupdated then
			slice:updateModel()
			sliceIndex = sliceIndex + 1
		end
	end
	_JPROFILER.pop("updateSlicesForChunk")
end

function processRenderChunks()
	_JPROFILER.push("processRenderChunks")
	for _, chunk in ipairs(renderChunks) do
		for _ = 1, WorldHeight / SliceHeight do
			if not chunk.slices[_] then
				chunk.slices[_] = NewChunkSlice(chunk.x, chunk.y + (_ - 1) * SliceHeight + 1, chunk.z, chunk)
			end
		end
		if #chunk.changes > 0 then
			chunk:updateModel()
		end
	end
	_JPROFILER.pop("processRenderChunks")
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
