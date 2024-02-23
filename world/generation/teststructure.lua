--TODO add documentation to make structures
--TODO made mod loader....
--TODO made a better structure (in the code) to make easier to register structures
--TODO avoid inverting Y and Z axes (need to fix : https://github.com/quentin452/LuaCraft/issues/12)

--THIS METHOD IS CORECT
function generatePillarEveryChunks(chunk, value)
	_JPROFILER.push("GameScene:update(generatePillarEveryChunks)")

	local size = chunk.size
	local datapointer = chunk.datapointer
	local pillarX = size / 2
	local pillarYStart = 0
	local pillarYEnd = size - 1
	local pillarZ = size / 2

	for pillarY = pillarYStart, pillarYEnd do
		local pillarIndex = pillarX + size * pillarZ + size * size * pillarY
		datapointer[pillarIndex] = value
	end
	--print("generatePillarEveryChunks" .. pillarX .. pillarYStart .. pillarZ)
	_JPROFILER.pop("GameScene:update(generatePillarEveryChunks)")
end

--THIS METHOD IS CORECT

function generatePillarAtFixedPosition(scene, x, y, z, value)
	_JPROFILER.push("GameScene:update(generatePillarAtFixedPosition)")

	local size = y + 1
	local floor = math.floor
	local chunkX, chunkY, chunkZ = floor(x / size), floor(y / size), floor(z / size)
	local chunkKey = ("%d/%d/%d"):format(chunkX, chunkY, chunkZ)

	local chunk = scene.chunkMap[chunkKey]

	if chunk then
		for posZ = 0, size - 1 do
			scene:setBlockFromWorld(x, y, z + posZ, value)
		end
		local blockKey = ("%d/%d/%d"):format(x, y, z)
		StructureMap[blockKey] = true
	end

	_JPROFILER.pop("GameScene:update(generatePillarAtFixedPosition)")
end
