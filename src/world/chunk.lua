--TODO FIX CANNOT PROFILE SOME SECTIONS WITH JPROF : causing crash during loading te viewer

function ReplaceChar(str, pos, r)
	return str:sub(1, pos - 1) .. r .. str:sub(pos + #r)
end

function NewChunk(x, z)
	_JPROFILER.push("NewChunk")

	local chunk = NewThing(x, 0, z)
	chunk.voxels = {}
	chunk.slices = {}
	chunk.heightMap = {}
	chunk.name = "chunk"

	chunk.ceiling = 120
	chunk.floor = 48
	chunk.requests = {}

	-- store a list of voxels to be updated on next modelUpdate
	chunk.changes = {}
	chunk.updatedSunLight = false
	chunk.isPopulated = false

	for i = 1, ChunkSize do
		chunk.heightMap[i] = {}
	end
	GenerateTerrain(chunk, x, z, StandardTerrain)

	local gx, gz = (chunk.x - 1) * ChunkSize + rand(0, 15), (chunk.z - 1) * ChunkSize + rand(0, 15)

	if choose({ true, false }) then
		--_JPROFILER.push("chooseCave")

		local caveCount1 = rand(1, 3)
		for i = 1, caveCount1 do
			NewCave(gx, rand(8, 64), gz)
		end
		local caveCount2 = rand(1, 2)
		for i = 1, caveCount2 do
			NewCave(gx, rand(48, 80), gz)
		end
		--_JPROFILER.pop("chooseCave")
	end

	chunk.sunlight = function(self)
		--_JPROFILER.push("sunlight")

		for i = 1, ChunkSize do
			for j = 1, ChunkSize do
				local gx, gz = (self.x - 1) * ChunkSize + i - 1, (self.z - 1) * ChunkSize + j - 1

				if self.heightMap[i] and self.heightMap[i][j] then
					local this = self.heightMap[i][j]

					if i == 1 or this > (self.heightMap[i - 1] and self.heightMap[i - 1][j] or 0) + 1 then
						NewSunlightDownAddition(gx - 1, this, gz, 15)
					end

					if j == 1 or this > self.heightMap[i][j - 1] then
						NewSunlightDownAddition(gx, this, gz - 1, 15)
					end
					if i == ChunkSize or this > self.heightMap[i + 1][j] then
						NewSunlightDownAddition(gx + 1, this, gz, 15)
					end
					if j == ChunkSize or this > self.heightMap[i][j + 1] then
						NewSunlightDownAddition(gx, this, gz + 1, 15)
					end
				end
			end
		end
		--_JPROFILER.pop("sunlight")

		--LightingUpdate()
	end

	chunk.processRequests = function(self)
		--_JPROFILER.push("processRequests")

		for j = 1, #self.requests do
			local block = self.requests[j]
			if not TileCollisions(self:getVoxel(block.x, block.y, block.z)) then
				self:setVoxel(block.x, block.y, block.z, block.value, 15)
			end
		end
		--_JPROFILER.pop("processRequests")

		--LightingUpdate()
	end

	-- populate chunk with trees and flowers
	chunk.populate = function(self)
		--_JPROFILER.push("populate")

		for i = 1, ChunkSize do
			if self.heightMap[i] then
				for j = 1, ChunkSize do
					if self.heightMap[i][j] then
						local height = self.heightMap[i][j]
						local xx = (self.x - 1) * ChunkSize + i
						local zz = (self.z - 1) * ChunkSize + j

						if TileCollisions(self:getVoxel(i, height, j)) then
							for _, func in ipairs(populateChunkModLoader["chunkPopulateTag"]) do
								func(self, i, height, j)
							end
						end
					end
				end
			end
		end
		--_JPROFILER.pop("populate")
	end

	-- get voxel id of the voxel in this chunk's coordinate space
	chunk.getVoxel = function(self, x, y, z)
		if self.voxels == nil or self.voxels[x] == nil or self.voxels[x][z] == nil then
			return 0, 0, 0
		end
		x, y, z = math.floor(x), math.floor(y), math.floor(z)

		-- Calculate string indices once
		local startIndex = (y - 1) * TileDataSize + 1
		local endIndex = startIndex + 2

		-- Check if coordinates are within bounds
		if x >= 1 and x <= ChunkSize and z >= 1 and z <= ChunkSize and y >= 1 and y <= WorldHeight then
			-- Extract all three bytes at once
			local byte1, byte2, byte3 = string.byte(self.voxels[x][z], startIndex, endIndex)
			return byte1, byte2, byte3
		end

		return 0, 0, 0
	end

	chunk.getVoxelFirstData = function(self, x, y, z)
		x = math.floor(x)
		y = math.floor(y)
		z = math.floor(z)
		if x <= ChunkSize and x >= 1 and z <= ChunkSize and z >= 1 and y >= 1 and y <= WorldHeight then
			return string.byte(self.voxels[x][z]:sub((y - 1) * TileDataSize + 2, (y - 1) * TileDataSize + 2))
		end

		return 0
	end

	chunk.getVoxelSecondData = function(self, x, y, z)
		x = math.floor(x)
		y = math.floor(y)
		z = math.floor(z)
		if x <= ChunkSize and x >= 1 and z <= ChunkSize and z >= 1 and y >= 1 and y <= WorldHeight then
			return string.byte(self.voxels[x][z]:sub((y - 1) * TileDataSize + 3, (y - 1) * TileDataSize + 3))
		end

		return 0
	end

	chunk.setVoxelRaw = function(self, x, y, z, blockvalue, light)
		--_JPROFILER.push("setVoxelRaw")

		if self.voxels == nil or self.voxels[x] == nil or self.voxels[x][z] == nil then
			return 0, 0, 0
		end
		if x <= ChunkSize and x >= 1 and z <= ChunkSize and z >= 1 and y >= 1 and y <= WorldHeight then
			local gx, gy, gz = (self.x - 1) * ChunkSize + x - 1, y, (self.z - 1) * ChunkSize + z - 1
			self.voxels[x][z] = ReplaceChar(self.voxels[x][z], (y - 1) * TileDataSize + 1, string.char(blockvalue))

			self.changes[#self.changes + 1] = { x, y, z }
		end
		--_JPROFILER.pop("setVoxelRaw")
	end
	-- set voxel id of the voxel in this chunk's coordinate space
	chunk.setVoxel = function(self, x, y, z, blockvalue, manuallyPlaced)
		--_JPROFILER.push("frame")

		--_JPROFILER.push("setVoxel")

		if manuallyPlaced == nil then
			manuallyPlaced = false
		end
		x, y, z = math.floor(x), math.floor(y), math.floor(z)

		local gx, gy, gz = (self.x - 1) * ChunkSize + x - 1, y, (self.z - 1) * ChunkSize + z - 1

		if x >= 1 and x <= ChunkSize and y >= 1 and y <= WorldHeight and z >= 1 and z <= ChunkSize then
			local sunget = self:getVoxel(x, y + 1, z)
			local sunlight = self:getVoxelFirstData(x, y + 1, z)

			local inDirectSunlight = TileLightable(sunget) and sunlight == 15
			local placingLocalSource = false
			local destroyLight = false

			if TileLightable(blockvalue) then
				if inDirectSunlight then
					NewSunlightDownAddition(gx, gy, gz, sunlight)
				else
					for dx = -1, 1 do
						for dy = -1, 1 do
							for dz = -1, 1 do
								NewSunlightAdditionCreation(gx + dx, gy + dy, gz + dz)
							end
						end
					end
				end

				if manuallyPlaced then
					local source = TileLightSource(blockvalue)
					if source > 0 then
						NewLocalLightAddition(gx, gy, gz, source)
						placingLocalSource = true
					else
						for dx = -1, 1 do
							for dy = -1, 1 do
								for dz = -1, 1 do
									NewLocalLightAdditionCreation(gx + dx, gy + dy, gz + dz)
								end
							end
						end
					end
				end
			else
				NewSunlightDownSubtraction(gx, gy - 1, gz)

				if TileSemiLightable(blockvalue) and inDirectSunlight and manuallyPlaced then
					NewSunlightAdditionCreation(gx, gy + 1, gz)
				end

				if not TileSemiLightable(blockvalue) or manuallyPlaced then
					destroyLight = not TileSemiLightable(blockvalue)

					for dx = -1, 1 do
						for dy = -1, 1 do
							for dz = -1, 1 do
								local nget = GetVoxelFirstData(gx + dx, gy + dy, gz + dz)
								if nget < 15 then
									NewSunlightSubtraction(gx + dx, gy + dy, gz + dz, nget + 1)
								end
							end
						end
					end
				end
			end

			local source = TileLightSource(self:getVoxel(x, y, z))
			if source > 0 and TileLightSource(blockvalue) == __AIR_Block then
				NewLocalLightSubtraction(gx, gy, gz, source + 1)
				destroyLight = true
			end

			if manuallyPlaced then
				if destroyLight then
					for dx = -1, 1 do
						for dy = -1, 1 do
							for dz = -1, 1 do
								local nget = GetVoxelSecondData(gx + dx, gy + dy, gz + dz)
								if nget < 15 then
									NewLocalLightSubtraction(gx + dx, gy + dy, gz + dz, nget + 1)
								end
							end
						end
					end
				end

				if TileSemiLightable(blockvalue) and not placingLocalSource then
					for dx = -1, 1 do
						for dy = -1, 1 do
							for dz = -1, 1 do
								NewLocalLightAdditionCreation(gx + dx, gy + dy, gz + dz)
							end
						end
					end
				end
			end
			if blockvalue ~= -1 then
				self.voxels[x][z] = ReplaceChar(self.voxels[x][z], (y - 1) * TileDataSize + 1, string.char(blockvalue))

				self.changes[#self.changes + 1] = { x, y, z }
			end
		end
		--_JPROFILER.pop("setVoxel")
		--_JPROFILER.pop("frame")

		--	LightingUpdate()
	end

	chunk.setVoxelData = function(self, x, y, z, blockvalue)
		--_JPROFILER.push("setVoxelData")

		x = math.floor(x)
		y = math.floor(y)
		z = math.floor(z)
		if x <= ChunkSize and x >= 1 and z <= ChunkSize and z >= 1 and y >= 1 and y <= WorldHeight then
			self.voxels[x][z] = ReplaceChar(self.voxels[x][z], (y - 1) * TileDataSize + 2, string.char(blockvalue))

			self.changes[#self.changes + 1] = { x, y, z }
		end
		--_JPROFILER.pop("setVoxelData")
	end

	-- sunlight data
	chunk.setVoxelFirstData = function(self, x, y, z, blockvalue)
		--_JPROFILER.push("setVoxelFirstData")

		x = math.floor(x)
		y = math.floor(y)
		z = math.floor(z)
		if x <= ChunkSize and x >= 1 and z <= ChunkSize and z >= 1 and y >= 1 and y <= WorldHeight then
			self.voxels[x][z] = ReplaceChar(self.voxels[x][z], (y - 1) * TileDataSize + 2, string.char(blockvalue))

			self.changes[#self.changes + 1] = { x, y, z }
		end
		--_JPROFILER.pop("setVoxelFirstData")
	end

	-- local light data
	chunk.setVoxelSecondData = function(self, x, y, z, blockvalue)
		--_JPROFILER.push("setVoxelSecondData")

		x = math.floor(x)
		y = math.floor(y)
		z = math.floor(z)
		if x <= ChunkSize and x >= 1 and z <= ChunkSize and z >= 1 and y >= 1 and y <= WorldHeight then
			self.voxels[x][z] = ReplaceChar(self.voxels[x][z], (y - 1) * TileDataSize + 3, string.char(blockvalue))

			self.changes[#self.changes + 1] = { x, y, z }
		end
		--_JPROFILER.pop("setVoxelSecondData")
	end

	local function initSliceUpdates()
		--_JPROFILER.push("initSliceUpdates")

		sliceUpdates = {}
		for i = 1, WorldHeight / SliceHeight do
			sliceUpdates[i] = { false, false, false, false, false }
		end
		--_JPROFILER.pop("initSliceUpdates")

		return sliceUpdates
	end

	local function findUpdatedSlices(self, sliceUpdates)
		--_JPROFILER.push("findUpdatedSlices")

		local INDEX, NEG_X, POS_X, NEG_Z, POS_Z = 1, 2, 3, 4, 5

		for i = 1, #self.changes do
			local height = self.changes[i][2]
			local index = math.floor((height - 1) / SliceHeight) + 1

			if sliceUpdates[index] then
				sliceUpdates[index][INDEX] = true

				local floorHeight = math.floor(height / SliceHeight) + 1
				local ceilHeight = math.floor((height - 2) / SliceHeight) + 1

				if floorHeight > index and sliceUpdates[index + 1] then
					sliceUpdates[math.min(index + 1, #sliceUpdates)][INDEX] = true
				end
				if ceilHeight < index and sliceUpdates[index - 1] then
					sliceUpdates[math.max(index - 1, 1)][INDEX] = true
				end

				local xChange = self.changes[i][1]
				local zChange = self.changes[i][3]

				if xChange == 1 then
					sliceUpdates[index][NEG_X] = true
				elseif xChange == ChunkSize then
					sliceUpdates[index][POS_X] = true
				end

				if zChange == 1 then
					sliceUpdates[index][NEG_Z] = true
				elseif zChange == ChunkSize then
					sliceUpdates[index][POS_Z] = true
				end
			end
		end
		--_JPROFILER.pop("findUpdatedSlices")
	end

	function updateFlaggedSlices(self, sliceUpdates)
		--_JPROFILER.push("updateFlaggedSlices")

		for i = 1, WorldHeight / SliceHeight do
			if sliceUpdates[i][1] then
				if self.slices[i] then
					self.slices[i]:updateModel()
				end
			end
		end
		--_JPROFILER.pop("updateFlaggedSlices")
	end

	chunk.updateModel = function(self)
		--_JPROFILER.push("chunk.updateModel")
		local sliceUpdates = initSliceUpdates()
		findUpdatedSlices(self, sliceUpdates)
		updateFlaggedSlices(self, sliceUpdates)

		self.changes = {}
		--_JPROFILER.pop("chunk.updateModel")
	end
	_JPROFILER.pop("NewChunk")

	return chunk
end

function updateAllChunksModel()
	for _, chunk in ipairs(renderChunks) do
		chunk:updateModel()
	end
end
function CanDrawFace(get, thisTransparency)
	local tget = TileTransparency(get)

	-- Transparency of 0 is air, so can't draw any face
	if tget == 0 then
		return false
	end

	-- For tree leaves, transparency of 1 allows drawing all faces
	if tget == 1 then
		return true
	end

	-- Draw faces if the transparencies are different
	return tget ~= thisTransparency
end

local transparency3 = 3
local reusableModel = {}

function NewChunkSlice(x, y, z, parent)
	_JPROFILER.push("NewChunkSlice")

	local t = NewThing(x, y, z)
	t.parent = parent
	t.name = "chunkslice"
	local compmodel = Engine.newModel(nil, LightingTexture, { 0, 0, 0 })
	compmodel.culling = false
	t:assignModel(compmodel)
	t.enableBlockAndTilesModels = false
	t.updateModel = function(self)
		if not self or not self.parent or not self.model then
			return
		end

		reusableModel = {}

		for i = 1, ChunkSize do
			for j = self.y, self.y + SliceHeight - 1 do
				for k = 1, ChunkSize do
					local this, thisSunlight, thisLocalLight = self.parent:getVoxel(i, j, k)
					local thisLight = math.max(thisSunlight, thisLocalLight)
					local thisTransparency = TileTransparency(this)
					local scale = 1
					local x, y, z = (self.x - 1) * ChunkSize + i - 1, 1 * j * scale, (self.z - 1) * ChunkSize + k - 1

					if thisTransparency < transparency3 then
						TileRendering(self, i, j, k, x, y, z, thisLight, reusableModel, scale)
						BlockRendering(self, i, j, k, x, y, z, thisTransparency, thisLight, reusableModel, scale)
					end
				end
			end
		end

		if self.model then
			self.model:setVerts(reusableModel)
		end
	end

	t.destroyModel = function(self)
		self.model.dead = true
	end
	_JPROFILER.pop("NewChunkSlice")

	return t
end

-- used for building structures across chunk borders
-- by requesting a block to be built in a chunk that does not yet exist
function NewChunkRequest(gx, gy, gz, valueg)
	_JPROFILER.push("NewChunkRequest")

	-- assume structures can only cross one chunk
	local lx, ly, lz = Localize(gx, gy, gz)
	local chunk = GetChunk(gx, gy, gz)

	if chunk ~= nil then
		chunk.requests[#chunk.requests + 1] = { x = lx, y = ly, z = lz, value = valueg }
	end
	_JPROFILER.pop("NewChunkRequest")
end
