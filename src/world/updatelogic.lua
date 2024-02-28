--TODO FIX : chunks are not removed if there are outside of render distance
--TODO FIX : generate Trees after all active chunks getting generated : like that trees can be generated without cutting

ChunkSet = {}
ChunkHashTable = {}
CaveList = {}
ChunkRequests = {}
LightingQueue = {}
LightingRemovalQueue = {}
local previousRenderDistance = nil

function UpdateGame(dt)
	if gamestate == gamestatePlayingGame then
		local RenderDistance = getRenderDistanceValue()

		local playerX, playerY, playerZ = ThePlayer.x, ThePlayer.y, ThePlayer.z

		-- Generate and update chunks within render distance
		renderChunks = {}

		local playerChunkX = math.floor(playerX / ChunkSize)
		local playerChunkZ = math.floor(playerZ / ChunkSize)

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
						LuaCraftPrintLoggingNormal("Generated chunk with coordinates:", chunkX, chunkZ)
					end

					-- Only update chunks within render distance
					if distance < RenderDistance / ChunkSize then
						if chunk.updatedSunLight == false then
							chunk:sunlight()
							chunk.updatedSunLight = true
						elseif chunk.isPopulated == false then
							UpdateCaves()
							chunk:populate()
							chunk:processRequests()
							for _ = 1, WorldHeight / SliceHeight do
								chunk.slices[_] =
									NewChunkSlice(chunk.x, chunk.y + (_ - 1) * SliceHeight + 1, chunk.z, chunk)
							end
							--UpdateNeighboringChunks(chunk, playerY)
							chunk:updateModel()

							LightingUpdate()
							chunk.isPopulated = true
						end
						for i = 1, #chunk.slices do
							local chunkSlice = chunk.slices[i]
							chunkSlice.active = true
						end
						chunk.active = true
					else
						RemoveChunkAndChunkSliceModels(chunk)
					end

					if not isInTable(renderChunks, chunk) then
						table.insert(renderChunks, chunk)
					end
				end
			end
		end

		if RenderDistance ~= previousRenderDistance then
			updateAllChunksModel()
		end
		LogicAccumulator = LogicAccumulator + dt
		previousRenderDistance = RenderDistance

		-- update all things in ThingList update queue
		updateThingList(dt)
	end
end

--this remove all chunk and chunk slice even if the chunk is within the render distance
function DeactivateAllSlices(chunk)
	for i = 1, #chunk.slices do
		local chunkSlice = chunk.slices[i]
		chunkSlice.active = false
	end
end

function UpdateActiveChunkModel(chunk)
	if chunk.active then
		-- Only update the model if there are changes
		if #chunk.changes > 0 then
			chunk:updateModel()
		end

		local i = #chunk.slices
		while i > 0 do
			local chunkSlice = chunk.slices[i]
			if chunkSlice.active == false then
				LuaCraftPrintLoggingNormal(
					"Removed chunkSlice at coordinates: "
						.. chunkSlice.x
						.. ", "
						.. chunkSlice.y
						.. ", "
						.. chunkSlice.z
				)
				table.remove(chunk.slices, i)
				chunkSlice.alreadyrendered = false
			end
			i = i - 1
		end
	end
end

function UpdateRenderChunksTable(updatedRenderChunks)
	renderChunks = updatedRenderChunks
end

function RemoveChunkAndChunkSliceModels(chunk)
	DeactivateAllSlices(chunk)

	for j = #renderChunks, 1, -1 do
		if not renderChunks[j].active then
			table.remove(renderChunks, j)
		end
	end

	local updatedRenderChunks = {}

	for _, activeChunk in ipairs(renderChunks) do
		UpdateActiveChunkModel(activeChunk)
		if activeChunk.active then
			table.insert(updatedRenderChunks, activeChunk)
		end
		activeChunk.active = false
	end

	UpdateRenderChunksTable(updatedRenderChunks)
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
end
