-- create the mesh for the block cursor
local gamesceneblockCursor, blockCursorVisible
do
	local a = -0.005
	local b = 1.005
	gamesceneblockCursor = g3d.newModel({
		{ a, a, a },
		{ b, a, a },
		{ b, a, a },
		{ a, a, a },
		{ a, b, a },
		{ a, b, a },
		{ b, a, b },
		{ a, a, b },
		{ a, a, b },
		{ b, a, b },
		{ b, a, a },
		{ b, a, a },
		{ a, b, a },
		{ b, b, a },
		{ b, b, a },
		{ a, b, a },
		{ a, b, b },
		{ a, b, b },
		{ b, b, b },
		{ a, b, b },
		{ a, b, b },
		{ b, b, b },
		{ b, b, a },
		{ b, b, a },

		{ a, a, a },
		{ a, b, a },
		{ a, b, a },
		{ b, a, a },
		{ b, b, a },
		{ b, b, a },
		{ a, a, b },
		{ a, b, b },
		{ a, b, b },
		{ b, a, b },
		{ b, b, b },
		{ b, b, b },
	})

	-- Apply the texture pack to the model
	gamesceneblockCursor.texture = gamescenetexturepack
end
local buildx, buildy, buildz

function LeftClickGameScene(scene,size)
    -- left click to destroy blocks
	-- casts a ray from the camera five blocks in the look vector
	-- finds the first intersecting block
	_JPROFILER.push("GameScene:update(LEFTCLICK)")
	local vx, vy, vz = g3d.camera.getLookVector()
	local x, y, z = g3d.camera.position[1], g3d.camera.position[2], g3d.camera.position[3]
	local step = 0.1
	local floor = math.floor
	blockCursorVisible = false
	for i = step, 5, step do
		local bx, by, bz = floor(x + vx * i), floor(y + vy * i), floor(z + vz * i)
		local chunk = scene:getChunkFromWorld(bx, by, bz)
		if chunk then
			local lx, ly, lz = bx % size, by % size, bz % size
			if chunk:getBlock(lx, ly, lz) ~= 0 then
				gamesceneblockCursor:setTranslation(bx, by, bz)
				blockCursorVisible = true

				-- store the last position the ray was at
				-- as the position for building a block
				local li = i - step
				buildx, buildy, buildz = floor(x + vx * li), floor(y + vy * li), floor(z + vz * li)

				if leftClick then
					local x, y, z = chunk.cx, chunk.cy, chunk.cz
					chunk:setBlock(lx, ly, lz, 0)
					if not chunk.inRemeshQueue then
						scene:requestRemesh(chunk, true)
					end
					if lx >= size - 1 then
						scene:requestRemesh(scene.chunkMap[("%d/%d/%d"):format(x + 1, y, z)], true)
					end
					if lx <= 0 then
						scene:requestRemesh(scene.chunkMap[("%d/%d/%d"):format(x - 1, y, z)], true)
					end
					if ly >= size - 1 then
						scene:requestRemesh(scene.chunkMap[("%d/%d/%d"):format(x, y + 1, z)], true)
					end
					if ly <= 0 then
						scene:requestRemesh(scene.chunkMap[("%d/%d/%d"):format(x, y - 1, z)], true)
					end
					if lz >= size - 1 then
						scene:requestRemesh(scene.chunkMap[("%d/%d/%d"):format(x, y, z + 1)], true)
					end
					if lz <= 0 then
						scene:requestRemesh(scene.chunkMap[("%d/%d/%d"):format(x, y, z - 1)], true)
					end
				end

				break
			end
		end
	end
	_JPROFILER.pop("GameScene:update(LEFTCLICK)")
end

function RightClickGameScene(scene,size)
    _JPROFILER.push("GameScene:update(RIGHTCLICK)")
	-- right click to place blocks
	if rightClick and buildx then
		local chunk = scene:getChunkFromWorld(buildx, buildy, buildz)
		local lx, ly, lz = buildx % size, buildy % size, buildz % size
		if chunk then
			local x, y, z = chunk.cx, chunk.cy, chunk.cz
			chunk:setBlock(lx, ly, lz, 1)
			if not chunk.inRemeshQueue then
				scene:requestRemesh(chunk, true)
			end
			if lx >= size - 1 then
				scene:requestRemesh(scene.chunkMap[("%d/%d/%d"):format(x + 1, y, z)], true)
			end
			if lx <= 0 then
				scene:requestRemesh(scene.chunkMap[("%d/%d/%d"):format(x - 1, y, z)], true)
			end
			if ly >= size - 1 then
				scene:requestRemesh(scene.chunkMap[("%d/%d/%d"):format(x, y + 1, z)], true)
			end
			if ly <= 0 then
				scene:requestRemesh(scene.chunkMap[("%d/%d/%d"):format(x, y - 1, z)], true)
			end
			if lz >= size - 1 then
				scene:requestRemesh(scene.chunkMap[("%d/%d/%d"):format(x, y, z + 1)], true)
			end
			if lz <= 0 then
				scene:requestRemesh(scene.chunkMap[("%d/%d/%d"):format(x, y, z - 1)], true)
			end
		end
	end
	_JPROFILER.pop("GameScene:update(RIGHTCLICK)")
end

function CursorDrawingGameScene()
    if not blockCursorVisible then
        return
    end

    lg.setColor(0, 0, 0)
    lg.setWireframe(true)
    gamesceneblockCursor:draw()
    lg.setWireframe(false)
end