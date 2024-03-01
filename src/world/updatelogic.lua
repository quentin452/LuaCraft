--TODO FIX : trees sometimes has problems to be generated across chunk borders
--TODO FIX : major lags while using high render distance and caused by chunk.slices[i]:updateModel()
--TODO FIX CANNOT PROFILE THIS WITH JPROF : causing crash during closing the game

ChunkSet = {}
ChunkHashTable = {}
CaveList = {}
ChunkRequests = {}
LightingQueue = {}
LightingRemovalQueue = {}
ThingList = {}
local previousRenderDistance = nil
local updateCounter = 0
function isChunkLoaded(chunkX, chunkZ)
	return ChunkHashTable[ChunkHash(chunkX)] and ChunkHashTable[ChunkHash(chunkX)][ChunkHash(chunkZ)]
end
--how to call isChunkLoaded
--local gx, gy, gz = (self.x - 1) * ChunkSize + i, height, (self.z - 1) * ChunkSize + j
--local chunkX, chunkZ = math.floor(gx / ChunkSize), math.floor(gz / ChunkSize)
--if isChunkLoaded(chunkX, chunkZ) then
--	
--end

function UpdateGame(dt)
	--_JPROFILER.push("frame")
	if gamestate == gamestatePlayingGame then
		local RenderDistance = getRenderDistanceValue()
		if ThePlayer == nil then
			PlayerInit()
		end
		local playerX, playerY, playerZ = ThePlayer.x, ThePlayer.y, ThePlayer.z

		-- Generate and update chunks within render distance
		renderChunks = {}

		local playerChunkX = math.ceil(playerX / ChunkSize)
		local playerChunkZ = math.ceil(playerZ / ChunkSize)

		for distance = 0, RenderDistance / ChunkSize do
			for i = -distance, distance do
				for j = -distance, distance do
					local chunkX = playerChunkX + i
					local chunkZ = playerChunkZ + j

					local chunk = ChunkHashTable[ChunkHash(chunkX)]
						and ChunkHashTable[ChunkHash(chunkX)][ChunkHash(chunkZ)]

					if not chunk then
						chunk = NewChunk(chunkX, chunkZ)
						ChunkSet[chunk] = true
						ChunkHashTable[ChunkHash(chunkX)] = ChunkHashTable[ChunkHash(chunkX)] or {}
						ChunkHashTable[ChunkHash(chunkX)][ChunkHash(chunkZ)] = chunk
						--LuaCraftPrintLoggingNormal("Generated chunk with coordinates:", chunkX, chunkZ)
					elseif distance < RenderDistance / ChunkSize then
						processChunkUpdates(chunk)
					else
						local chunkDistanceX = math.abs(chunk.x - playerChunkX)
						local chunkDistanceZ = math.abs(chunk.z - playerChunkZ)
						local chunkDistance = math.sqrt(chunkDistanceX ^ 2 + chunkDistanceZ ^ 2)
						if chunkDistance > RenderDistance / ChunkSize then
							local key = ChunkHash(chunkX) .. ":" .. ChunkHash(chunkZ)
							coordCache[key] = nil

							for i = 1, #chunk.slices do
								local chunkSlice = chunk.slices[i]
								chunkSlice:destroy()
								chunkSlice:destroyModel()
								chunkSlice.enableBlockAndTilesModels = false
								chunk.slices[i] = nil
							end
						end
					end
				end
			end
		end

		if RenderDistance ~= previousRenderDistance then
			updateAllChunksModel()
		end

		LogicAccumulator = LogicAccumulator + dt
		previousRenderDistance = RenderDistance
		updateThingList(dt)
		--_JPROFILER.pop("UpdateGameDT")
	end
end

function processChunkUpdates(chunk)
	--_JPROFILER.push("processChunkUpdates")

	if chunk.updatedSunLight == false then
		chunk:sunlight()
		chunk.updatedSunLight = true
	elseif chunk.isPopulated == false then
		UpdateCaves()
		chunk:populate()
		chunk:processRequests()
		chunk.isPopulated = true
	elseif ThePlayer.IsPlayerHasSpawned == false then
		ChooseSpawnLocation()
		ThePlayer.IsPlayerHasSpawned = true
	elseif chunk.updatemodel == false then
		chunk:updateModel()
		chunk.updatemodel = true
	end
	if not isInTable(renderChunks, chunk) then
		table.insert(renderChunks, chunk)
	end
	updateCounter = updateCounter + 1
	--this is to force model updates for chunks : need to be optimized
	if updateCounter > 1500 then
		for i = 1, WorldHeight / SliceHeight do
			if chunk.slices[i] and not chunk.slices[i].isUpdating then
				chunk.slices[i]:updateModel()
			end
			updateCounter = 0
		end
	end

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
	LightingUpdate()
	--_JPROFILER.pop("processChunkUpdates")
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
	--_JPROFILER.push("updateThingList")

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
	--_JPROFILER.pop("updateThingList")
end
