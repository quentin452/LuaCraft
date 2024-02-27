function ReplaceChar(str, pos, r)
	return str:sub(1, pos - 1) .. r .. str:sub(pos + #r)
end

function NewChunk(x, z)
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

	for i = 1, ChunkSize do
		chunk.heightMap[i] = {}
	end
	chunk.isInitialLightningInititalized = false
	chunk.isPopulated = false
	chunk.isInitialized = false

	GenerateTerrain(chunk, x, z, StandardTerrain)

	local gx, gz = (chunk.x - 1) * ChunkSize + rand(0, 15), (chunk.z - 1) * ChunkSize + rand(0, 15)

	if choose({ true, false }) then
		local caveCount1 = rand(1, 3)
		for i = 1, caveCount1 do
			NewCave(gx, rand(8, 64), gz)
		end
		local caveCount2 = rand(1, 2)
		for i = 1, caveCount2 do
			NewCave(gx, rand(48, 80), gz)
		end
	end

	chunk.sunlight = function(self)
		for i = 1, ChunkSize do
			for j = 1, ChunkSize do
				local gx, gz = (self.x - 1) * ChunkSize + i - 1, (self.z - 1) * ChunkSize + j - 1
				local this = self.heightMap[i][j]

				if i == 1 or this > self.heightMap[i - 1][j] + 1 then
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
		--LightingUpdate()
	end

	chunk.processRequests = function(self)
		for j = 1, #self.requests do
			local block = self.requests[j]
			if not TileCollisions(self:getVoxel(block.x, block.y, block.z)) then
				self:setVoxel(block.x, block.y, block.z, block.value, 15)
			end
		end
		LightingUpdate()
	end

	-- populate chunk with trees and flowers
	chunk.populate = function(self)
		for i = 1, ChunkSize do
			for j = 1, ChunkSize do
				local height = self.heightMap[i][j]
				local xx = (self.x - 1) * ChunkSize + i
				local zz = (self.z - 1) * ChunkSize + j

				if TileCollisions(self:getVoxel(i, height, j)) then
					if love.math.random() < love.math.noise(xx / 64, zz / 64) * 0.02 then
						-- put a tree here
						GenerateTree(self, i, height, j)
						self:setVoxelRaw(i, height, j, __DIRT_Block, 15)
					elseif love.math.noise(xx / 32, zz / 32) > 0.9 and love.math.random() < 0.2 then
						-- put a random flower here
						local flowerID = love.math.random(__YELLO_FLOWER_Block, __ROSE_FLOWER_Block)
						self:setVoxelRaw(i, height + 1, j, flowerID, 15)
						-- LuaCraftPrintLoggingNormal("Height:", height, "xx:", xx, "zz:", zz)
					end
				end
			end
		end
	end

	-- get voxel id of the voxel in this chunk's coordinate space
	chunk.getVoxel = function(self, x, y, z)
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
		if x <= ChunkSize and x >= 1 and z <= ChunkSize and z >= 1 and y >= 1 and y <= WorldHeight then
			local gx, gy, gz = (self.x - 1) * ChunkSize + x - 1, y, (self.z - 1) * ChunkSize + z - 1
			self.voxels[x][z] = ReplaceChar(self.voxels[x][z], (y - 1) * TileDataSize + 1, string.char(blockvalue))

			self.changes[#self.changes + 1] = { x, y, z }
		end
	end

	-- set voxel id of the voxel in this chunk's coordinate space
	chunk.setVoxel = function(self, x, y, z, blockvalue, manuallyPlaced)
		if manuallyPlaced == nil then
			manuallyPlaced = false
		end
		x, y, z = math.floor(x), math.floor(y), math.floor(z)

		-- Précalculez les coordonnées globales
		local gx, gy, gz = (self.x - 1) * ChunkSize + x - 1, y, (self.z - 1) * ChunkSize + z - 1

		-- Vérifiez si les coordonnées sont dans la plage
		if x >= 1 and x <= ChunkSize and y >= 1 and y <= WorldHeight and z >= 1 and z <= ChunkSize then
			-- Stockez les valeurs pour éviter les appels de fonction répétés
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

			self.voxels[x][z] = ReplaceChar(self.voxels[x][z], (y - 1) * TileDataSize + 1, string.char(blockvalue))

			self.changes[#self.changes + 1] = { x, y, z }
		end
	end

	chunk.setVoxelData = function(self, x, y, z, blockvalue)
		x = math.floor(x)
		y = math.floor(y)
		z = math.floor(z)
		if x <= ChunkSize and x >= 1 and z <= ChunkSize and z >= 1 and y >= 1 and y <= WorldHeight then
			self.voxels[x][z] = ReplaceChar(self.voxels[x][z], (y - 1) * TileDataSize + 2, string.char(blockvalue))

			self.changes[#self.changes + 1] = { x, y, z }
		end
	end

	-- sunlight data
	chunk.setVoxelFirstData = function(self, x, y, z, blockvalue)
		x = math.floor(x)
		y = math.floor(y)
		z = math.floor(z)
		if x <= ChunkSize and x >= 1 and z <= ChunkSize and z >= 1 and y >= 1 and y <= WorldHeight then
			self.voxels[x][z] = ReplaceChar(self.voxels[x][z], (y - 1) * TileDataSize + 2, string.char(blockvalue))

			self.changes[#self.changes + 1] = { x, y, z }
		end
	end

	-- local light data
	chunk.setVoxelSecondData = function(self, x, y, z, blockvalue)
		x = math.floor(x)
		y = math.floor(y)
		z = math.floor(z)
		if x <= ChunkSize and x >= 1 and z <= ChunkSize and z >= 1 and y >= 1 and y <= WorldHeight then
			self.voxels[x][z] = ReplaceChar(self.voxels[x][z], (y - 1) * TileDataSize + 3, string.char(blockvalue))

			self.changes[#self.changes + 1] = { x, y, z }
		end
	end

	-- update this chunk's model slices based on what changes it has stored
	chunk.updateModel = function(self)
		local sliceUpdates = {}

		for i = 1, WorldHeight / SliceHeight do
			sliceUpdates[i] = { false, false, false, false, false }
		end
		-- find which slices need to be updated
		for i = 1, #self.changes do
			local index = math.floor((self.changes[i][2] - 1) / SliceHeight) + 1
			if sliceUpdates[index] ~= nil then
				sliceUpdates[index][1] = true

				if math.floor(self.changes[i][2] / SliceHeight) + 1 > index and sliceUpdates[index + 1] ~= nil then
					sliceUpdates[math.min(index + 1, #sliceUpdates)][1] = true
				end
				if
					math.floor((self.changes[i][2] - 2) / SliceHeight) + 1 < index
					and sliceUpdates[index - 1] ~= nil
				then
					sliceUpdates[math.max(index - 1, 1)][1] = true
				end

				--LuaCraftPrintLoggingNormal(self.changes[i][1], self.changes[i][2], self.changes[i][3])
				-- neg x
				if self.changes[i][1] == 1 then
					sliceUpdates[index][2] = true
					--LuaCraftPrintLoggingNormal("neg x")
				end
				-- pos x
				if self.changes[i][1] == ChunkSize then
					sliceUpdates[index][3] = true
					--LuaCraftPrintLoggingNormal("pos x")
				end
				-- neg z
				if self.changes[i][3] == 1 then
					sliceUpdates[index][4] = true
					--LuaCraftPrintLoggingNormal("neg z")
				end
				-- pos z
				if self.changes[i][3] == ChunkSize then
					sliceUpdates[index][5] = true
					--LuaCraftPrintLoggingNormal("pos z")
				end
			end
		end

		-- update slices that were flagged in the previous step
		for i = 1, WorldHeight / SliceHeight do
			if sliceUpdates[i][1] then
				self.slices[i]:updateModel()

				if sliceUpdates[i][2] then
					local chunk = GetChunkRaw(self.x - 1, self.z)
					if chunk then
						local neighborSlice = chunk.slices[i]
						if neighborSlice then
							neighborSlice:updateModel()
						end
					end
				end

				if sliceUpdates[i][3] then
					local chunk = GetChunkRaw(self.x + 1, self.z)
					if chunk then
						local neighborSlice = chunk.slices[i]
						if neighborSlice then
							neighborSlice:updateModel()
						end
					end
				end

				if sliceUpdates[i][4] or sliceUpdates[i][5] then
					local chunk = GetChunkRaw(self.x, self.z - 1)
					if chunk then
						local neighborSlice = chunk.slices[i]
						if neighborSlice then
							neighborSlice:updateModel()
						end
					end
				end

				if sliceUpdates[i][4] or sliceUpdates[i][5] then
					local chunk = GetChunkRaw(self.x, self.z + 1)
					if chunk then
						local neighborSlice = chunk.slices[i]
						if neighborSlice then
							neighborSlice:updateModel()
						end
					end
				end
			end
		end

		self.changes = {}
	end

	return chunk
end

function CanDrawFace(get, thisTransparency)
	local tget = TileTransparency(get)

	-- tget > 0 means can only draw faces from outside in (bc transparency of 0 is air)
	-- must be different transparency to draw, except for tree leaves which have transparency of 1
	return (tget ~= thisTransparency or tget == 1) and tget > 0
end
function NewChunkSlice(x, y, z, parent)
	local t = NewThing(x, y, z)
	t.parent = parent
	t.name = "chunkslice"
	local compmodel = Engine.newModel(nil, LightingTexture, { 0, 0, 0 })
	compmodel.culling = false
	t:assignModel(compmodel)
	t.active = true
	t.updateModel = function(self)
		--[[local model = {}

		for i = 1, ChunkSize do
			for j = self.y, self.y + SliceHeight - 1 do
				for k = 1, ChunkSize do
					local this, thisSunlight, thisLocalLight = self.parent:getVoxel(i, j, k)
					local thisLight = math.max(thisSunlight, thisLocalLight)
					local thisTransparency = TileTransparency(this)
					local scale = 1
					local x, y, z = (self.x - 1) * ChunkSize + i - 1, 1 * j * scale, (self.z - 1) * ChunkSize + k - 1

					if thisTransparency < 3 then
						TileRendering(self, i, j, k, x, y, z, thisLight, model, scale)
						BlockRendering(self, i, j, k, x, y, z, thisTransparency, thisLight, model, scale)
					end
				end
			end
		end

		self.model:setVerts(model)
		--]]
	end

	--	t:updateModel()
	return t
end

function TileRendering(self, i, j, k, x, y, z, thisLight, model, scale)
	local this = self.parent:getVoxel(i, j, k)
	if TileModel(this) == 1 then
		local otx, oty = NumberToCoord(TileTextures(this)[1], 16, 16)
		otx = otx + 16 * thisLight
		local otx2, oty2 = otx + 1, oty + 1
		local tx, ty = otx * TileWidth / LightValues, oty * TileHeight
		local tx2, ty2 = otx2 * TileWidth / LightValues, oty2 * TileHeight

		local diagLong = 0.7071 * scale * 0.5 + 0.5
		local diagShort = -0.7071 * scale * 0.5 + 0.5

		local vertices = {}

		for _, v in ipairs({
			{ diagShort, 0, diagShort, tx2, ty2 },
			{ diagLong, 0, diagLong, tx, ty2 },
			{ diagShort, scale, diagShort, tx2, ty },
			{ diagLong, 0, diagLong, tx, ty2 },
			{ diagLong, scale, diagLong, tx, ty },
			{ diagShort, scale, diagShort, tx2, ty },
		}) do
			table.insert(vertices, { x + v[1], y + v[2], z + v[3], v[4], v[5] })
		end

		for _, v in ipairs(vertices) do
			model[#model + 1] = v
		end
	end
end

function BlockRendering(self, i, j, k, x, y, z, thisTransparency, thisLight, model, scale)
	-- top
	local get = self.parent:getVoxel(i, j - 1, k)
	if CanDrawFace(get, thisTransparency) then
		local otx, oty = NumberToCoord(TileTextures(get)[math.min(2, #TileTextures(get))], 16, 16)
		otx = otx + 16 * thisLight
		local otx2, oty2 = otx + 1, oty + 1
		local tx, ty = otx * TileWidth / LightValues, oty * TileHeight
		local tx2, ty2 = otx2 * TileWidth / LightValues, oty2 * TileHeight

		model[#model + 1] = { x, y, z, tx, ty }
		model[#model + 1] = { x + scale, y, z, tx2, ty }
		model[#model + 1] = { x, y, z + scale, tx, ty2 }
		model[#model + 1] = { x + scale, y, z, tx2, ty }
		model[#model + 1] = { x + scale, y, z + scale, tx2, ty2 }
		model[#model + 1] = { x, y, z + scale, tx, ty2 }
	end

	-- bottom
	local get = self.parent:getVoxel(i, j + 1, k)
	if CanDrawFace(get, thisTransparency) then
		local otx, oty = NumberToCoord(TileTextures(get)[math.min(3, #TileTextures(get))], 16, 16)
		otx = otx + 16 * math.max(thisLight - 3, 0)
		local otx2, oty2 = otx + 1, oty + 1
		local tx, ty = otx * TileWidth / LightValues, oty * TileHeight
		local tx2, ty2 = otx2 * TileWidth / LightValues, oty2 * TileHeight

		model[#model + 1] = { x + scale, y + scale, z, tx2, ty }
		model[#model + 1] = { x, y + scale, z, tx, ty }
		model[#model + 1] = { x, y + scale, z + scale, tx, ty2 }
		model[#model + 1] = { x + scale, y + scale, z + scale, tx2, ty2 }
		model[#model + 1] = { x + scale, y + scale, z, tx2, ty }
		model[#model + 1] = { x, y + scale, z + scale, tx, ty2 }
	end

	-- positive x
	local get = self.parent:getVoxel(i - 1, j, k)
	if i == 1 then
		local chunkGet = GetChunk(x - 1, y, z)
		if chunkGet ~= nil then
			get = chunkGet:getVoxel(ChunkSize, j, k)
		end
	end
	if CanDrawFace(get, thisTransparency) then
		local otx, oty = NumberToCoord(TileTextures(get)[1], 16, 16)
		otx = otx + 16 * math.max(thisLight - 2, 0)
		local otx2, oty2 = otx + 1, oty + 1
		local tx, ty = otx * TileWidth / LightValues, oty * TileHeight
		local tx2, ty2 = otx2 * TileWidth / LightValues, oty2 * TileHeight

		model[#model + 1] = { x, y + scale, z, tx2, ty }
		model[#model + 1] = { x, y, z, tx2, ty2 }
		model[#model + 1] = { x, y, z + scale, tx, ty2 }
		model[#model + 1] = { x, y + scale, z + scale, tx, ty }
		model[#model + 1] = { x, y + scale, z, tx2, ty }
		model[#model + 1] = { x, y, z + scale, tx, ty2 }
	end

	-- negative x
	local get = self.parent:getVoxel(i + 1, j, k)
	if i == ChunkSize then
		local chunkGet = GetChunk(x + 1, y, z)
		if chunkGet ~= nil then
			get = chunkGet:getVoxel(1, j, k)
		end
	end
	if CanDrawFace(get, thisTransparency) then
		local otx, oty = NumberToCoord(TileTextures(get)[1], 16, 16)
		otx = otx + 16 * math.max(thisLight - 2, 0)
		local otx2, oty2 = otx + 1, oty + 1
		local tx, ty = otx * TileWidth / LightValues, oty * TileHeight
		local tx2, ty2 = otx2 * TileWidth / LightValues, oty2 * TileHeight

		model[#model + 1] = { x + scale, y, z, tx, ty2 }
		model[#model + 1] = { x + scale, y + scale, z, tx, ty }
		model[#model + 1] = { x + scale, y, z + scale, tx2, ty2 }
		model[#model + 1] = { x + scale, y + scale, z, tx, ty }
		model[#model + 1] = { x + scale, y + scale, z + scale, tx2, ty }
		model[#model + 1] = { x + scale, y, z + scale, tx2, ty2 }
	end

	-- positive z
	local get = self.parent:getVoxel(i, j, k - 1)
	if k == 1 then
		local chunkGet = GetChunk(x, y, z - 1)
		if chunkGet ~= nil then
			get = chunkGet:getVoxel(i, j, ChunkSize)
		end
	end
	if CanDrawFace(get, thisTransparency) then
		local otx, oty = NumberToCoord(TileTextures(get)[1], 16, 16)
		otx = otx + 16 * math.max(thisLight - 1, 0)
		local otx2, oty2 = otx + 1, oty + 1
		local tx, ty = otx * TileWidth / LightValues, oty * TileHeight
		local tx2, ty2 = otx2 * TileWidth / LightValues, oty2 * TileHeight

		model[#model + 1] = { x, y, z, tx, ty2 }
		model[#model + 1] = { x, y + scale, z, tx, ty }
		model[#model + 1] = { x + scale, y, z, tx2, ty2 }
		model[#model + 1] = { x, y + scale, z, tx, ty }
		model[#model + 1] = { x + scale, y + scale, z, tx2, ty }
		model[#model + 1] = { x + scale, y, z, tx2, ty2 }
	end

	-- negative z
	local get = self.parent:getVoxel(i, j, k + 1)
	if k == ChunkSize then
		local chunkGet = GetChunk(x, y, z + 1)
		if chunkGet ~= nil then
			get = chunkGet:getVoxel(i, j, 1)
		end
	end
	if CanDrawFace(get, thisTransparency) then
		local otx, oty = NumberToCoord(TileTextures(get)[1], 16, 16)
		otx = otx + 16 * math.max(thisLight - 1, 0)
		local otx2, oty2 = otx + 1, oty + 1
		local tx, ty = otx * TileWidth / LightValues, oty * TileHeight
		local tx2, ty2 = otx2 * TileWidth / LightValues, oty2 * TileHeight

		model[#model + 1] = { x, y + scale, z + scale, tx2, ty }
		model[#model + 1] = { x, y, z + scale, tx2, ty2 }
		model[#model + 1] = { x + scale, y, z + scale, tx, ty2 }
		model[#model + 1] = { x + scale, y + scale, z + scale, tx, ty }
		model[#model + 1] = { x, y + scale, z + scale, tx2, ty }
		model[#model + 1] = { x + scale, y, z + scale, tx, ty2 }
	end
end

-- used for building structures across chunk borders
-- by requesting a block to be built in a chunk that does not yet exist
function NewChunkRequest(gx, gy, gz, valueg)
	-- assume structures can only cross one chunk
	local lx, ly, lz = Localize(gx, gy, gz)
	local chunk = GetChunk(gx, gy, gz)

	if chunk ~= nil then
		chunk.requests[#chunk.requests + 1] = { x = lx, y = ly, z = lz, value = valueg }
	end
end
