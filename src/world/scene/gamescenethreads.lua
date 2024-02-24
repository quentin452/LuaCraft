local threadpool = {}

-- load up some threads so that chunk meshing won't block the main thread
for i = 1, 8 do
	threadpool[i] = love.thread.newThread("src/world/chunk/chunkremesh.lua")
end
local threadchannels = {}

gamescenethreadusage = 0

function ThreadCountGameScene(threadpool, gamescenethreadusage)
	-- count how many threads are being used right now
	_JPROFILER.push("GameScene:update(THREADSCOUNTS)")
	for _, thread in ipairs(threadpool) do
		if thread:isRunning() then
			gamescenethreadusage = gamescenethreadusage + 1
		end

		local err = thread:getError()
		assert(not err, err)
	end
	_JPROFILER.pop("GameScene:update(THREADSCOUNTS)")

	return gamescenethreadusage
end

function RemeshChunkInQueueGameScene(scene)
	_JPROFILER.push("GameScene:update(REMESHTHECHUNKINQUEUE)")
	-- remesh the chunks in the queue
	-- NOTE: if this happens multiple times in a frame, weird things can happen? idk why
	function getNeighborData(chunkMap, x, y, z)
		local neighbor, n1, n2, n3, n4, n5, n6
		neighbor = chunkMap[("%d/%d/%d"):format(x + 1, y, z)]
		if neighbor and not neighbor.dead then
			n1 = neighbor.data
		end
		neighbor = chunkMap[("%d/%d/%d"):format(x - 1, y, z)]
		if neighbor and not neighbor.dead then
			n2 = neighbor.data
		end
		neighbor = chunkMap[("%d/%d/%d"):format(x, y + 1, z)]
		if neighbor and not neighbor.dead then
			n3 = neighbor.data
		end
		neighbor = chunkMap[("%d/%d/%d"):format(x, y - 1, z)]
		if neighbor and not neighbor.dead then
			n4 = neighbor.data
		end
		neighbor = chunkMap[("%d/%d/%d"):format(x, y, z + 1)]
		if neighbor and not neighbor.dead then
			n5 = neighbor.data
		end
		neighbor = chunkMap[("%d/%d/%d"):format(x, y, z - 1)]
		if neighbor and not neighbor.dead then
			n6 = neighbor.data
		end

		return n1, n2, n3, n4, n5, n6
	end
	if gamescenethreadusage < #threadpool and #scene.remeshQueue > 0 then
		local chunk = table.remove(scene.remeshQueue, 1)
		if chunk and not chunk.dead then
			for _, thread in ipairs(threadpool) do
				if not thread:isRunning() then
					local x, y, z = chunk.cx, chunk.cy, chunk.cz
					local n1, n2, n3, n4, n5, n6 = getNeighborData(scene.chunkMap, x, y, z)

					thread:start(chunk.hash, chunk.data, n1, n2, n3, n4, n5, n6)
					threadchannels[chunk.hash] = chunk
					break
				end
			end
		end
	end
	_JPROFILER.pop("GameScene:update(REMESHTHECHUNKINQUEUE)")

	return gamescenethreadusage
end

function ListenFinishedMeshesOnthreadGameScene()
	-- listen for finished meshes on the thread channels
	_JPROFILER.push("GameScene:update(LISTENFINISHEDMESHESONTHREAD)")
	for channel, chunk in pairs(threadchannels) do
		local data = love.thread.getChannel(channel):pop()
		if data then
			threadchannels[channel] = nil
			if chunk.model then
				chunk.model.mesh:release()
			end
			chunk.model = nil
			if data.count > 0 then
				chunk.model = g3d.newModel(data.count, gamescenetexturepack)
				chunk.model.mesh:setVertices(data.data)
				chunk.model:setTranslation(chunk.x, chunk.y, chunk.z)
				chunk.inRemeshQueue = false
				break
			end
		end
	end
	_JPROFILER.pop("GameScene:update(LISTENFINISHEDMESHESONTHREAD)")
end
