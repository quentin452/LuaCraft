local ChunkSize = 16
--TODO FIX : currently render distance does not support renderdistance lower than 6 (it seem to be caused by Slices not being created)
--TODO FIX : Slices stop to be created after generating some chunks
--TODO FIX : sometimes when i create a world the first time , the world become empty

--TODO MADE : support renderdistance setting from settingshandling/filesystem
local RenderDistance = 6 * ChunkSize
ChunkSet = {}
ChunkHashTable = {}
CaveList = {}
ChunkRequests = {}
LightingQueue = {}
LightingRemovalQueue = {}

function UpdateGame(dt)
	if gamestate == gamestatePlayingGame then
		local playerX, playerY, playerZ = ThePlayer.x, ThePlayer.y, ThePlayer.z

		-- Generate and update chunks within render distance
		local renderChunks = {}
		--table.remove(renderChunks)

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
						UpdateCaves()
						LuaCraftPrintLoggingNormal("Generated chunk with coordinates:", chunkX, chunkZ)
					end

					local mx, y, mz = chunk.x, chunk.y, chunk.z
					local dx, dy, dz = playerX - mx, playerY - y, playerZ - mz

					-- Calculate Euclidean distance
					local chunkDistance = math.sqrt(dx * dx + dy * dy + dz * dz)

					if chunkDistance < RenderDistance then
						if not chunk.isInitialLightningInititalized then
							chunk:sunlight()
							chunk.isInitialLightningInititalized = true
						elseif not chunk.isPopulated then
							chunk:populate()
							chunk.isPopulated = true
						elseif not chunk.isInitialized then
							chunk.changes = {}

							-- Populate the chunk before initializing slices
							for sliceIndex = 1, WorldHeight / SliceHeight do
								if not chunk.slices[sliceIndex] then
									local sliceY = chunk.y + (sliceIndex - 1) * SliceHeight + 1
									chunk.slices[sliceIndex] = NewChunkSlice(chunk.x, sliceY, chunk.z, chunk)
								end
							end

							chunk:processRequests()
							for _, chunkSlice in ipairs(chunk.slices) do
								renderChunkSlice(chunkSlice, ThePlayer.x, ThePlayer.y, ThePlayer.z)
							end
							chunk.isInitialized = true
						end

						chunk.active = true
						for i = 1, #chunk.slices do
							--	LuaCraftPrintLoggingNormal("test2")
							local chunkSlice = chunk.slices[i]
							chunkSlice.active = true
						end
					else
						chunk.active = false
						for i = 1, #chunk.slices do
							--LuaCraftPrintLoggingNormal("test2")
							local chunkSlice = chunk.slices[i]
							chunkSlice.active = false
						end

						--it seem that table.remove hre is doesn't work
						for j = #renderChunks, 1, -1 do
							if not renderChunks[j].active then
								table.remove(renderChunks, j)
							end
						end
						

						-- LuaCraftPrintLoggingNormal("Chunk at coordinates (", chunk.x, ",", chunk.z, ") is inactive")
					end

					if not isInTable(renderChunks, chunk) then
						table.insert(renderChunks, chunk)
					end
				end
			end
		end

		-- Update the rendered chunks
		for _, chunk in ipairs(renderChunks) do
			if chunk.isInitialized and chunk.active then
				-- Only update the model if there are changes
				if #chunk.changes > 0 then
					chunk:updateModel()
				end
		
				for _, chunkSlice in ipairs(chunk.slices) do
					if chunkSlice.active == false then
						-- Remove the inactive ChunkSlice
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
				end
			end
		end
		
		LogicAccumulator = LogicAccumulator + dt

		-- update all things in ThingList update queue
		updateThingList(dt)
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
end
function isInTable(tbl, value)
	for _, v in ipairs(tbl) do
		if v == value then
			return true
		end
	end
	return false
end
function renderChunkSlice(chunkSlice, playerX, playerY, playerZ)
	--LuaCraftPrintLoggingNormal("Rendering chunk slice:", chunkSlice.x, chunkSlice.y, chunkSlice.z)
	local model = {}

	for i = 1, ChunkSize do
		for j = chunkSlice.y, chunkSlice.y + SliceHeight - 1 do
			for k = 1, ChunkSize do
				local this, thisSunlight, thisLocalLight = chunkSlice.parent:getVoxel(i, j, k)
				local thisLight = math.max(thisSunlight, thisLocalLight)
				local thisTransparency = TileTransparency(this)
				local scale = 1
				local x, y, z =
					(chunkSlice.x - 1) * ChunkSize + i - 1, 1 * j * scale, (chunkSlice.z - 1) * ChunkSize + k - 1

				if thisTransparency < 3 then
					TileRendering(chunkSlice, i, j, k, x, y, z, thisLight, model, scale)
					BlockRendering(chunkSlice, i, j, k, x, y, z, thisTransparency, thisLight, model, scale)
				end
			end
		end
	end

	chunkSlice.model:setVerts(model)
	chunkSlice.alreadyrendered = true
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
end
