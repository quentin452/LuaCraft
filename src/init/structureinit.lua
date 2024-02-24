local floor = math.floor

--TODO MADE STRUCTURE GENERATION INTO AN ANOTHER THREAD
--TODO improve check like isChunkFullyGenerated , IsStructureIsGenerated (by using at the place a isChunkLoaded?????)
--TODO PROBABLY IN CHUNK script i need to add a timer to avoid generating at infinit time caused by generateStructuresatRandomLocation????

--THIS METHOD IS WORK CORRECTLY BUT HE GENERATE AT INFINITE TIME
function generateStructuresatRandomLocation(scene, value)
	_JPROFILER.push("GameScene:update(generateStructuresatRandomLocation)")

	local structureGenerator = Config:getRandomLocationStructureGenerator()

	for _ = 1, 1 do
		local size = math.random(5, 10)
		local x = math.random(0, 100)
		local y = math.random(100, 200)
		local z = math.random(0, 50)

		local floor = math.floor
		local chunkX, chunkY, chunkZ = floor(x / size), floor(y / size), floor(z / size)

		if isChunkFullyGenerated(scene, chunkX, chunkY, chunkZ) and not IsStructureIsGenerated(x, y, z) then
			structureGenerator(scene, value)
			local blockKey = ("%d/%d/%d"):format(x, y, z)
			StructureMap[blockKey] = true
			LuaCraftPrintLoggingNormal("Pilier généré avec succès à la position :", x, y, z)
			scene:requestRemesh(scene:getChunkFromWorld(x, y, z), true)
		end
	end

	_JPROFILER.pop("GameScene:update(generateStructuresatRandomLocation)")
end
function isPlayerInRange(playerX, playerY, playerZ, structureX, structureY, structureZ)
	local distanceSquared = (playerX - structureX) ^ 2 + (playerY - structureY) ^ 2 + (playerZ - structureZ) ^ 2
	return distanceSquared <= globalRenderDistance * 22 ^ 2
end

--THIS METHOD IS WORK CORRECTLY

function generateStructuresInPlayerRange(scene, size)
	--_JPROFILER.push("GameScene:update(generateStructuresInPlayerRange)")
	local playerX, playerY, playerZ = g3d.camera.position[1], g3d.camera.position[2], g3d.camera.position[3]
	local generatorFunc, storedX, storedY, storedZ = Config:getFixedPositionStructureGeneratorUsingPlayerRangeWithXYZ()

	if
		not IsStructureIsGenerated(storedX, storedY, storedZ)
		and isPlayerInRange(playerX, playerY, playerZ, storedX, storedY, storedZ)
	then
		local chunkX, chunkY, chunkZ = floor(storedX / size), floor(storedY / size), floor(storedZ / size)

		if
			isChunkFullyGenerated(scene, chunkX, chunkY, chunkZ)
			and not IsStructureIsGenerated(storedX, storedY, storedZ)
		then
			generatorFunc(scene, storedX, storedY, storedZ, 1)
			local blockKey = ("%d/%d/%d"):format(storedX, storedY, storedZ)
			StructureMap[blockKey] = true
		end
	end

	--_JPROFILER.pop("GameScene:update(generateStructuresInPlayerRange)")
end

--THIS METHOD IS WORK CORRECTLY
function generateStructuresatFixedPositions(scene, size)
	--_JPROFILER.push("generateStructuresatFixedPositions")

	local generatorFunc, storedX, storedY, storedZ =
		Config:getFixedPositionStructureGeneratorUsingIsChunkFullyGeneratedWithXYZ()

	local chunkX, chunkY, chunkZ = floor(storedX / size), floor(storedY / size), floor(storedZ / size)

	if
		isChunkFullyGenerated(scene, chunkX, chunkY, chunkZ) and not IsStructureIsGenerated(storedX, storedY, storedZ)
	then
		generatorFunc(scene, storedX, storedY, storedZ, 1)
		local blockKey = ("%d/%d/%d"):format(storedX, storedY, storedZ)
		StructureMap[blockKey] = true
		LuaCraftPrintLoggingNormal("Structure générée avec succès à la position :", storedX, storedY, storedZ)
	end

	--_JPROFILER.pop("generateStructuresatFixedPositions")
end

function StructureGenFinal(scene, size)
	generateStructuresatFixedPositions(scene, size)
	generateStructuresInPlayerRange(scene, size)
	--generateStructuresatRandomLocation(scene, 1)
end
