-- get voxel by looking at chunk at given position's local coordinate system
function GetVoxelGeneric(x, y, z, getFunction)
	local chunk, cx, cy, cz = GetChunk(x, y, z)
	local result = 0
	if chunk ~= nil then
		result = getFunction(chunk, cx, cy, cz)
	end
	return result
end

function GetVoxel(x, y, z)
	return GetVoxelGeneric(x, y, z, function(chunk, cx, cy, cz)
		return chunk:getVoxel(cx, cy, cz)
	end)
end

function GetVoxelData(x, y, z)
	return GetVoxelGeneric(x, y, z, function(chunk, cx, cy, cz)
		local v, d = chunk:getVoxel(cx, cy, cz)
		return d
	end)
end

function GetVoxelFirstData(x, y, z)
	return GetVoxelGeneric(x, y, z, function(chunk, cx, cy, cz)
		return chunk:getVoxelFirstData(cx, cy, cz)
	end)
end

function GetVoxelSecondData(x, y, z)
	return GetVoxelGeneric(x, y, z, function(chunk, cx, cy, cz)
		return chunk:getVoxelSecondData(cx, cy, cz)
	end)
end

function SetVoxelGeneric(x, y, z, value, setFunction)
	local chunk, cx, cy, cz = GetChunk(x, y, z)
	if chunk ~= nil then
		setFunction(chunk, cx, cy, cz, value)
		return true
	end
	return false
end

function SetVoxel(x, y, z, value)
	return SetVoxelGeneric(x, y, z, value, function(chunk, cx, cy, cz, value)
		chunk:setVoxel(cx, cy, cz, value)
	end)
end

function SetVoxelData(x, y, z, value)
	return SetVoxelGeneric(x, y, z, value, function(chunk, cx, cy, cz, value)
		chunk:setVoxelData(cx, cy, cz, value)
	end)
end

function SetVoxelFirstData(x, y, z, value)
	return SetVoxelGeneric(x, y, z, value, function(chunk, cx, cy, cz, value)
		chunk:setVoxelFirstData(cx, cy, cz, value)
	end)
end

function SetVoxelSecondData(x, y, z, value)
	return SetVoxelGeneric(x, y, z, value, function(chunk, cx, cy, cz, value)
		chunk:setVoxelSecondData(cx, cy, cz, value)
	end)
end
