--TODO DON4T USE OBJECTS IN NewCave to reduce memory usage
--TODO Try removing CaveList
function UpdateCaves()
	_JPROFILER.push("UpdateCaves")

	local i = 1
	while i <= #CaveList do
		_JPROFILER.push("CaveListQuery")
		local shouldContinue = CaveList[i]:query()
		_JPROFILER.pop("CaveListQuery")

		if CaveList[i].lifeTimer <= 0 then
			table.remove(CaveList, i)
		else
			i = i + 1
		end

		if shouldContinue then
			_JPROFILER.push("RestartCaveListIteration")
			i = 1
			_JPROFILER.pop("RestartCaveListIteration")
		end
	end

	_JPROFILER.pop("UpdateCaves")
end

local function caveQuery(cave)
	local sinThetaCosPhi = math.sin(cave.theta) * math.cos(cave.phi)
	local sinPhi = math.sin(cave.phi)
	local cosThetaCosPhi = math.cos(cave.theta) * math.cos(cave.phi)

	cave.x, cave.y, cave.z = cave.x + sinThetaCosPhi, cave.y + sinPhi, cave.z + cosThetaCosPhi

	cave.theta = cave.theta + cave.deltaTheta * 0.2
	cave.deltaTheta = cave.deltaTheta * 0.9 + math.random() - math.random()
	cave.phi = cave.phi / 2 + cave.deltaPhi / 4
	cave.deltaPhi = cave.deltaPhi * 0.75 + math.random() - math.random()

	if cave.carveIndex >= cave.radius then
		cave:carve()
		cave.carveIndex = 0
	end
	cave.carveIndex = cave.carveIndex + 1

	cave.lifeTimer = cave.lifeTimer - 1
	return cave.lifeTimer > 0
end

local function caveCarve(cave)
	if GetVoxel(cave.x, cave.y, cave.z) ~= 0 then
		local halfRandom = math.random() / 2
		local squaredRadius = cave.radius * cave.radius

		for i = -cave.radius, cave.radius do
			for j = -cave.radius, cave.radius do
				for k = -cave.radius, cave.radius do
					local distanceSquared = i * i + j * j + k * k
					if distanceSquared + halfRandom < squaredRadius then
						local gx, gy, gz = cave.x + i, cave.y + j, cave.z + k
						local chunk, cx, cy, cz = GetChunk(gx, gy, gz)
						if chunk ~= nil then
							chunk:setVoxelRawNotSupportLight(cx, cy, cz, Tiles.AIR_Block.id)
							if cy == chunk.heightMap[cx][cz] then
								NewLightOperation(gx, gy, gz, LightOpe.SunDownAdd.id, LightSources[15])
							end
						end
					end
				end
			end
		end
	end
end

function NewCave(x, y, z)
	_JPROFILER.push("NewCave")
	local cave = {
		x = x,
		y = y,
		z = z,
		lifeTimer = rand(64, 256),
		theta = math.random() * math.pi * 2,
		deltaTheta = 0,
		phi = math.random() * math.pi * 2,
		deltaPhi = 0,
		radius = rand(2, 3, 0.1),
		carveIndex = 0,
		query = caveQuery,
		carve = caveCarve,
	}
	CaveList[#CaveList + 1] = cave
	cave = nil
	_JPROFILER.pop("NewCave")
	return cave
end
