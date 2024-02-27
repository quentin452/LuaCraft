local ChunkSize = 16
--TODO FIX : currently render distance does not support renderdistance lower than 6
--TODO FIX : when i reecreate world the world is empty
--TODO FIX : some issues accross chunks on blocks
--TODO FIX : the render distance wont move with the player
--TODO FIX : Caves are generated after ChunkSlice get init

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

		--todo need to fix some things before
		-- Generate Chunks within render distance
		for i = math.floor(playerX / ChunkSize) - RenderDistance / ChunkSize, math.floor(playerX / ChunkSize) + RenderDistance / ChunkSize do
			for j = math.floor(playerZ / ChunkSize) - RenderDistance / ChunkSize, math.floor(playerZ / ChunkSize) + RenderDistance / ChunkSize do
				if not ChunkHashTable[ChunkHash(i)] or not ChunkHashTable[ChunkHash(i)][ChunkHash(j)] then
					local chunk = NewChunk(i, j)
					ChunkSet[chunk] = true
					ChunkHashTable[ChunkHash(i)] = ChunkHashTable[ChunkHash(i)] or {}
					ChunkHashTable[ChunkHash(i)][ChunkHash(j)] = chunk
					UpdateCaves()
					LuaCraftPrintLoggingNormal("Generated chunk with coordinates:", i, j)
				end
			end
		end

		local renderChunks = getRenderChunks(playerX, playerY, playerZ)
		for _, chunk in ipairs(renderChunks) do
			if chunk.isInitialized and chunk.active then
				-- Only update the model if there are changes
				if #chunk.changes > 0 then
					chunk:updateModel()
				end

				for _, chunkSlice in ipairs(chunk.slices) do
					if chunkSlice.active then
						if not chunkSlice.alreadyrendered then
							renderChunkSlice(chunkSlice, playerX, playerY, playerZ)
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
function getRenderChunks(playerX, playerY, playerZ)
	local renderChunks = {}

	-- Première étape: Récupérer tous les chunks dans la sphère de rendu sans vérifier la distance individuelle
	for chunk in pairs(ChunkSet) do
		local mx, y, mz = chunk.x, chunk.y, chunk.z
		table.insert(renderChunks, chunk)
	end

	-- Deuxième étape: Mettre à jour uniquement les chunks actifs parmi cette sphère
	for _, chunk in ipairs(renderChunks) do
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
				for i = 1, WorldHeight / SliceHeight do
					chunk.slices[i] = NewChunkSlice(chunk.x, chunk.y + (i - 1) * SliceHeight + 1, chunk.z, chunk)
				end
				chunk.changes = {}
				chunk:processRequests()
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
	end

	return renderChunks
end
function renderChunkSlice(chunkSlice, playerX, playerY, playerZ)
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
					-- LuaCraftPrintLoggingNormal("Rendering voxel:", i, j, k, "at position:", x, y, z)
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
