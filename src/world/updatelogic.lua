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
		table.remove(renderChunks)

		for i = math.floor(playerX / ChunkSize) - RenderDistance / ChunkSize, math.floor(playerX / ChunkSize) + RenderDistance / ChunkSize do
			for j = math.floor(playerZ / ChunkSize) - RenderDistance / ChunkSize, math.floor(playerZ / ChunkSize) + RenderDistance / ChunkSize do
				local chunk = ChunkHashTable[ChunkHash(i)] and ChunkHashTable[ChunkHash(i)][ChunkHash(j)]

				if not chunk then
					chunk = NewChunk(i, j)
					ChunkSet[chunk] = true
					ChunkHashTable[ChunkHash(i)] = ChunkHashTable[ChunkHash(i)] or {}
					ChunkHashTable[ChunkHash(i)][ChunkHash(j)] = chunk
					UpdateCaves()
					LuaCraftPrintLoggingNormal("Generated chunk with coordinates:", i, j)
				end

				local mx, y, mz = chunk.x, chunk.y, chunk.z
				local dx, dy, dz = playerX - mx, playerY - y, playerZ - mz

				-- Calculate Euclidean distance
				local distance = math.sqrt(dx * dx + dy * dy + dz * dz)

				if distance < RenderDistance then
					if not chunk.isInitialLightningInititalized then
						chunk:sunlight()
						chunk.isInitialLightningInititalized = true
					elseif not chunk.isPopulated then
						chunk:populate()
						chunk.isPopulated = true
					elseif not chunk.isInitialized then
						chunk.changes = {}
						chunk:processRequests()
						for i = 1, WorldHeight / SliceHeight do
							local sliceY = chunk.y + (i - 1) * SliceHeight + 1
							print("Creating slice at Y:", sliceY)
							chunk.slices[i] = NewChunkSlice(chunk.x, sliceY, chunk.z, chunk)
						end						
						chunk.isInitialized = true
					end
					chunk.active = true
					for _, chunkSlice in ipairs(chunk.slices) do
						chunkSlice.active = true
					end
				else
					chunk.active = false
					for _, chunkSlice in ipairs(chunk.slices) do
						chunkSlice.active = false
					end
				end

				table.insert(renderChunks, chunk)
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
					if chunkSlice.active then
						if not chunkSlice.alreadyrendered then
							-- renderChunkSlice(chunkSlice, playerX, playerY, playerZ)
						end
					else
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

function renderChunkSlice(chunkSlice, playerX, playerY, playerZ)
	print("Rendering chunk slice:", chunkSlice.x, chunkSlice.y, chunkSlice.z)
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
