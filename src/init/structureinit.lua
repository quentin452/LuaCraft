--TODO MADE STRUCTURE GENERATION INTO AN ANOTHER THREAD
--TODO improve check like isChunkFullyGenerated , IsStructureIsGenerated (by using at the place a isChunkLoaded?????)
--TODO PROBABLY IN CHUNK script i need to add a timer to avoid generating at infinit time caused by generateStructuresatRandomLocation????

--THIS METHOD IS WORK CORRECTLY BUT HE GENERATE AT INFINITE TIME
function generateStructuresatRandomLocation(scene, numStructures, value)
	_JPROFILER.push("GameScene:update(generateStructuresatRandomLocation)")

	for i = 1, numStructures do
		local size = math.random(5, 10)
		local x = math.random(0, 100)
		local y = math.random(100, 200)
		local z = math.random(0, 50)

		local floor = math.floor
		local chunkX, chunkY, chunkZ = floor(x / size), floor(y / size), floor(z / size)

		if isChunkFullyGenerated(scene, chunkX, chunkY, chunkZ) and not IsStructureIsGenerated(x, y, z) then
			generatePillarAtRandomLocation(scene, value)
			local blockKey = ("%d/%d/%d"):format(x, y, z)
			StructureMap[blockKey] = true
			print("Pilier généré avec succès à la position :", x, y, z)
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
function generateStructuresInPlayerRange(scene)
	_JPROFILER.push("GameScene:update(generateStructuresInRange)")
	local playerX, playerY, playerZ = g3d.camera.position[1], g3d.camera.position[2], g3d.camera.position[3]

	local Pillars = {
		{ x = 40, y = 40, z = 22 },
		{ x = 40, y = 40, z = 22 },
		{ x = 40, y = 40, z = 22 },
	}

	for _, Pillars in ipairs(Pillars) do
		if
			not IsStructureIsGenerated(Pillars.x, Pillars.y, Pillars.z)
			and isPlayerInRange(playerX, playerY, playerZ, Pillars.x, Pillars.y, Pillars.z)
		then
			generatePillarAtFixedPosition(scene, Pillars.x, Pillars.y, Pillars.z, 1)
			local blockKey = ("%d/%d/%d"):format(Pillars.x, Pillars.y, Pillars.z)
			StructureMap[blockKey] = true
			print("Pilier généré avec succès à la position :", Pillars.x, Pillars.y, Pillars.z)
			scene:requestRemesh(scene:getChunkFromWorld(Pillars.x, Pillars.y, Pillars.z), true)
		end
	end
	_JPROFILER.pop("GameScene:update(generateStructuresInRange)")
end

--THIS METHOD IS WORK CORRECTLY
function generateStructuresatFixedPositions(scene, size)
	local floor = math.floor

	local function generatePillarAndRemesh(x, y, z)
		generatePillarAtFixedPosition(scene, x, y, z, 1)
		local blockKey = ("%d/%d/%d"):format(x, y, z)
		StructureMap[blockKey] = true
		print("Pilier généré avec succès à la position :", x, y, z)
	end

	local specificX1, specificY1, specificZ1 = 0, 20, 20
	local chunkX1, chunkY1, chunkZ1 = floor(specificX1 / size), floor(specificY1 / size), floor(specificZ1 / size)

	local specificX2, specificY2, specificZ2 = 0, 21, 20
	local chunkX2, chunkY2, chunkZ2 = floor(specificX2 / size), floor(specificY2 / size), floor(specificZ2 / size)

	local specificX3, specificY3, specificZ3 = 0, 22, 20
	local chunkX3, chunkY3, chunkZ3 = floor(specificX3 / size), floor(specificY3 / size), floor(specificZ3 / size)

	if
		isChunkFullyGenerated(scene, chunkX1, chunkY1, chunkZ1)
		and not IsStructureIsGenerated(specificX1, specificY1, specificZ1)
	then
		generatePillarAndRemesh(specificX1, specificY1, specificZ1)
	end

	if
		isChunkFullyGenerated(scene, chunkX2, chunkY2, chunkZ2)
		and not IsStructureIsGenerated(specificX2, specificY2, specificZ2)
	then
		generatePillarAndRemesh(specificX2, specificY2, specificZ2)
	end

	if
		isChunkFullyGenerated(scene, chunkX3, chunkY3, chunkZ3)
		and not IsStructureIsGenerated(specificX3, specificY3, specificZ3)
	then
		generatePillarAndRemesh(specificX3, specificY3, specificZ3)
	end
end

function StructureGenFinal(scene,size)
    generateStructuresatFixedPositions(scene, size)
	generateStructuresInPlayerRange(scene)
	generateStructuresatRandomLocation(scene, 1, 1)
end