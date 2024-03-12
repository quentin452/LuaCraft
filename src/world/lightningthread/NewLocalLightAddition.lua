local SIXDIRECTIONS = {
	{ x = 0, y = -1, z = 0 }, -- Down
	{ x = 0, y = 1, z = 0 }, -- Up
	{ x = 1, y = 0, z = 0 }, -- Right
	{ x = -1, y = 0, z = 0 }, -- Left
	{ x = 0, y = 0, z = 1 }, -- Forward
	{ x = 0, y = 0, z = -1 }, -- Backward
}
function NewLocalLightAddition(x, y, z, value)
	local t = { x = x, y = y, z = z, value = value, queryType = "NewLocalLightAddition" }
	LightingQueue:push(t)
end

function queryNewLocalLightAddition(lthing)
	local chunk = GetChunk(lthing.x, lthing.y, lthing.z)
	if chunk == nil then
		return
	end
	local cx, cy, cz = Localize(lthing.x, lthing.y, lthing.z)
	local val, dis, dat = chunk:getVoxel(cx, cy, cz)
	if TileSemiLightable(val) and dat < lthing.value then
		chunk:setVoxelSecondData(cx, cy, cz, lthing.value)
		if lthing.value > 1 then
			for _, dir in ipairs(SIXDIRECTIONS) do
				NewLocalLightAddition(lthing.x + dir.x, lthing.y + dir.y, lthing.z + dir.z, lthing.value - 1)
			end
		end
	end
end
