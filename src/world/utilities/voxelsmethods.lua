-- get voxel by looking at chunk at given position's local coordinate system
function GetVoxel(x, y, z)
	local chunk, cx, cy, cz = GetChunk(x, y, z)
	local v = 0
	if chunk ~= nil then
		v = chunk:getVoxel(cx, cy, cz)
	end
	return v
end
function GetVoxelData(x, y, z)
	local chunk, cx, cy, cz = GetChunk(x, y, z)
	local v = 0
	local d = 0
	if chunk ~= nil then
		v, d = chunk:getVoxel(cx, cy, cz)
	end
	return d
end

function GetVoxelFirstData(x, y, z)
	local chunk, cx, cy, cz = GetChunk(x, y, z)
	if chunk ~= nil then
		return chunk:getVoxelFirstData(cx, cy, cz)
	end
	return 0
end

function GetVoxelSecondData(x, y, z)
	local chunk, cx, cy, cz = GetChunk(x, y, z)
	if chunk ~= nil then
		return chunk:getVoxelSecondData(cx, cy, cz)
	end
	return 0
end

function SetVoxel(x, y, z, value)
	local chunk, cx, cy, cz = GetChunk(x, y, z)
	if chunk ~= nil then
		chunk:setVoxel(cx, cy, cz, value)
		return true
	end
	return false
end
function SetVoxelData(x, y, z, value)
	local chunk, cx, cy, cz = GetChunk(x, y, z)
	if chunk ~= nil then
		chunk:setVoxelData(cx, cy, cz, value)
		return true
	end
	return false
end

function SetVoxelFirstData(x, y, z, value)
	local chunk, cx, cy, cz = GetChunk(x, y, z)
	if chunk ~= nil then
		chunk:setVoxelFirstData(cx, cy, cz, value)
		return true
	end
	return false
end
function SetVoxelSecondData(x, y, z, value)
	local chunk, cx, cy, cz = GetChunk(x, y, z)
	if chunk ~= nil then
		chunk:setVoxelSecondData(cx, cy, cz, value)
		return true
	end
	return false
end
