--TODO DON4T USE OBJECTS IN NewCave to reduce memory usage

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

function NewCave(x, y, z)
	_JPROFILER.push("NewCave")
	local t = {
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
	}
	t.query = function(self)
		local sinThetaCosPhi = math.sin(self.theta) * math.cos(self.phi)
		local sinPhi = math.sin(self.phi)
		local cosThetaCosPhi = math.cos(self.theta) * math.cos(self.phi)

		self.x, self.y, self.z = self.x + sinThetaCosPhi, self.y + sinPhi, self.z + cosThetaCosPhi

		self.theta = self.theta + self.deltaTheta * 0.2
		self.deltaTheta = self.deltaTheta * 0.9 + math.random() - math.random()
		self.phi = self.phi / 2 + self.deltaPhi / 4
		self.deltaPhi = self.deltaPhi * 0.75 + math.random() - math.random()

		if self.carveIndex >= self.radius then
			self:carve()
			self.carveIndex = 0
		end
		self.carveIndex = self.carveIndex + 1

		self.lifeTimer = self.lifeTimer - 1
		return self.lifeTimer > 0
	end

	t.carve = function(self)
		if GetVoxel(self.x, self.y, self.z) ~= 0 then
			local halfRandom = math.random() / 2
			local squaredRadius = self.radius * self.radius

			for i = -self.radius, self.radius do
				for j = -self.radius, self.radius do
					for k = -self.radius, self.radius do
						local distanceSquared = i * i + j * j + k * k
						if distanceSquared + halfRandom < squaredRadius then
							local gx, gy, gz = self.x + i, self.y + j, self.z + k
							local chunk, cx, cy, cz = GetChunk(gx, gy, gz)
							if chunk ~= nil then
								chunk:setVoxelRawNotSupportLight(cx, cy, cz, Tiles.AIR_Block.id)
								if cy == chunk.heightMap[cx][cz] then
									NewLightOperation(gx, gy, gz, LightOpe.SunDownAdd.id, LightSources[15])
									--[[	ThreadLightingChannel:push({"LightOperation",
										gx,
										gy,
										gz,
										LightOpe.SunDownAdd.id,
										LightSources[15],
									})]]
								end
							end
						end
					end
				end
			end
		end
	end
	CaveList[#CaveList + 1] = t
	_JPROFILER.pop("NewCave")
	return t
end
