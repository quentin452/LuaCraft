local ChunkSize = 16
local RenderDistance = 8 * ChunkSize
--ChunkSet = {}
--ChunkHashTable = {}
--CaveList = {}
function UpdateGame(dt)
	if gamestate == gamestatePlayingGame then
		local playerX, playerY, playerZ = ThePlayer.x, ThePlayer.y, ThePlayer.z

		--todo need to fix some things before
		-- Générer les chunks si nécessaire
		--	for i = math.floor(playerX / ChunkSize) - RenderDistance, math.floor(playerX / ChunkSize) + RenderDistance do
		--		for j = math.floor(playerZ / ChunkSize) - RenderDistance, math.floor(playerZ / ChunkSize) + RenderDistance do
		--			if not ChunkHashTable[ChunkHash(i)] or not ChunkHashTable[ChunkHash(i)][ChunkHash(j)] then
		--				local chunk = NewChunk(i, j)
		--				ChunkSet[chunk] = true
		--				ChunkHashTable[ChunkHash(i)] = ChunkHashTable[ChunkHash(i)] or {}
		--		ChunkHashTable[ChunkHash(i)][ChunkHash(j)] = chunk
		--		LuaCraftPrintLoggingNormal("Generated chunk with coordinates:", i, j)
		--	end
		--		end
		--	end

		local renderChunks = getRenderChunks(playerX, playerY, playerZ)
		for _, chunk in ipairs(renderChunks) do
			if chunk.isInitialized and chunk.active and #chunk.changes > 0 then
				chunk:updateModel()
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
		local dx, dy, dz = math.abs(playerX - mx), math.abs(playerY - y), math.abs(playerZ - mz)

		local distance = math.max(dx, dy, dz)

		if distance < RenderDistance then
			if not chunk.isInitialLightningInititalized then
				chunk:sunlight()
				chunk.isInitialLightningInititalized = true
			elseif not chunk.isPopulated then
				chunk:populate()
				chunk.isPopulated = true
			elseif not chunk.isInitialized then
				chunk:processRequests()
				chunk:initialize()
				chunk.isInitialized = true
			end
			--todo add a way to enable the render/update of the chunk but before i need to find in the code where the chunk render is , but i think its NewChunkSlice
			chunk.active = true
		else
			--todo add a way to disable the render/update of the chunk
			chunk.active = false
		end
	end

	return renderChunks
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
