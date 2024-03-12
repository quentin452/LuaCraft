local SIXDIRECTIONS = {
	{ x = 0, y = -1, z = 0 }, -- Down
	{ x = 0, y = 1, z = 0 }, -- Up
	{ x = 1, y = 0, z = 0 }, -- Right
	{ x = -1, y = 0, z = 0 }, -- Left
	{ x = 0, y = 0, z = 1 }, -- Forward
	{ x = 0, y = 0, z = -1 }, -- Backward
}
function NewSunlightAddition(x, y, z, value)
	local t = { x = x, y = y, z = z, value = value, queryType = "NewSunlightAddition" }
	LightingQueue:push(t)
end

function queryNewSunlightAddition(lthing)
	local cget, cx, cy, cz = GetChunk(lthing.x, lthing.y, lthing.z)
	if cget == nil then
		return
	end
	local val = cget:getVoxel(cx, cy, cz)
	local dat = cget:getVoxelFirstData(cx, cy, cz)
	if lthing.value >= 0 and TileSemiLightable(val) and dat < lthing.value then
		cget:setVoxelFirstData(cx, cy, cz, lthing.value)
		for _, dir in ipairs(SIXDIRECTIONS) do
			NewSunlightAddition(lthing.x + dir.x, lthing.y + dir.y, lthing.z + dir.z, lthing.value - 1)
		end
	end
end
