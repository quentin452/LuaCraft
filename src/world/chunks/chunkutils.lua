--TODO Prevent Block Placements methods should be upgraded/debuggified

function ReplaceChar(str, pos, r)
	return str:sub(1, pos - 1) .. r .. str:sub(pos + #r)
end
function PreventBlockPlacementOnThePlayer(gx, gy, gz)
	--prevent block placements on the player
	local playerX, playerY, playerZ = ThePlayer.x, ThePlayer.y, ThePlayer.z
	local range1 = 1
	local range2 = 0.1
	local playerXFloor = math.floor(playerX)
	local playerYFloor = math.floor(playerY)
	local playerZFloor = math.floor(playerZ)
	if
		(
			love.keyboard.isDown("space")
			and gx >= playerXFloor + 0.5 - range1
			and gx <= playerXFloor + range1
			and gy >= playerYFloor
			and gy <= playerYFloor + 1
			and gz >= playerZFloor - range1
			and gz <= playerZFloor + 0.5 + range1
		)
		or (
			not love.keyboard.isDown("space")
			and gx >= playerXFloor - range2
			and gx <= playerXFloor + range2
			and gy >= playerYFloor
			and gy <= playerYFloor + 1
			and gz >= playerZFloor - range2
			and gz <= playerZFloor + range2
		)
	then
		return true
	end
	return false
end

local function isBlockInTileModelTable(block)
	local value = GetValueFromTilesById(block)
	if value then
		local blockstringname = value.blockstringname
		if Tiles[blockstringname].BlockOrLiquidOrTile == TileMode.TileMode then
			return true
		end
	end
	return false
end

function PreventBlockPlacementOnCertainBlocksLikeFlower(self, x, y, z, blockvalue)
	--prevent placing a block on an another block(like flowers)
	local blockBelow = self:getVoxel(x, y - 1, z)
	local blockAbove = self:getVoxel(x, y + 1, z)
	if
		(isBlockInTileModelTable(blockvalue))
		and ((isBlockInTileModelTable(blockBelow)) or (isBlockInTileModelTable(blockAbove)))
	then
		return true
	end
	return false
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

function SetVoxelDataInternal(self, x, y, z, blockvalue, dataIndex)
	x = math.floor(x)
	y = math.floor(y)
	z = math.floor(z)
	if x <= ChunkSize and x >= 1 and z <= ChunkSize and z >= 1 and y >= 1 and y <= WorldHeight then
		local dataIndexOffset = (dataIndex == "First" and 2 or 3)
		self.voxels[x][z] =
			ReplaceChar(self.voxels[x][z], (y - 1) * TileDataSize + dataIndexOffset, string.char(blockvalue))
		self.changes[#self.changes + 1] = { x, y, z }
	end
end
function InitSliceUpdates()
	for i = 1, WorldHeight / SliceHeight do
		SliceUpdates[i] = { false, false, false, false, false }
	end
	return SliceUpdates
end
function FindUpdatedSlices(self, sliceUpdates)
	_JPROFILER.push("findUpdatedSlices")
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
	_JPROFILER.pop("findUpdatedSlices")
end
function UpdateFlaggedSlices(self, sliceUpdates)
	_JPROFILER.push("updateFlaggedSlices")
	for i = 1, WorldHeight / SliceHeight do
		if sliceUpdates[i][1] then
			if self.slices[i] then
				self.slices[i]:updateModel()
			end
		end
	end
	_JPROFILER.pop("updateFlaggedSlices")
end
function NewChunkSlice(x, y, z, parent)
	local t = NewThing(x, y, z)
	t.parent = parent
	t.name = "chunkslice"
	local compmodel = Engine.newModel(nil, LightingTexture, { 0, 0, 0 })
	compmodel.culling = false
	t:assignModel(compmodel)
	t.isUpdating = false
	t.updateModel = function(self)
		if not self or not self.parent or not self.model then
			return
		end
		self.isUpdating = true
		ChunkSliceModels = {}
		for i = 1, ChunkSize do
			for j = self.y, self.y + SliceHeight - 1 do
				for k = 1, ChunkSize do
					local this, thisSunlight, thisLocalLight = self.parent:getVoxel(i, j, k)
					local thisLight = math.max(thisSunlight, thisLocalLight)
					local thisTransparency = TileTransparency(this)
					local scale = 1
					local x, y, z = (self.x - 1) * ChunkSize + i - 1, 1 * j * scale, (self.z - 1) * ChunkSize + k - 1
					if thisTransparency < transparency3 then
						TileRendering(self, i, j, k, x, y, z, thisLight, ChunkSliceModels, scale)
						BlockRendering(self, i, j, k, x, y, z, thisTransparency, thisLight, ChunkSliceModels, scale)
					end
				end
			end
		end
		if self.model then
			self.model:setVerts(ChunkSliceModels)
		end
		self.isUpdating = false
	end
	t.destroyModel = function(self)
		self.model.dead = true
	end
	return t
end
