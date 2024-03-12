local SIXDIRECTIONS = {
	{ x = 0, y = -1, z = 0 }, -- Down
	{ x = 0, y = 1, z = 0 }, -- Up
	{ x = 1, y = 0, z = 0 }, -- Right
	{ x = -1, y = 0, z = 0 }, -- Left
	{ x = 0, y = 0, z = 1 }, -- Forward
	{ x = 0, y = 0, z = -1 }, -- Backward
}
function NewLocalLightForceAddition(x, y, z, value)
	local t = { x = x, y = y, z = z, value = value , queryType = "NewLocalLightForceAddition"}
	LightingQueue:push(t)
end

function queryNewLocalLightForceAddition(lthing)
	local cget, cx, cy, cz = GetChunk(lthing.x, lthing.y, lthing.z)
		if cget == nil then
			return
		end
		local val, dis, dat = cget:getVoxel(cx, cy, cz)
		if lthing.value >= 0 and TileSemiLightable(val) then
			cget:setVoxelSecondData(cx, cy, cz, lthing.value)
			for _, dir in ipairs(SIXDIRECTIONS) do
				NewLocalLightAddition(lthing.x + dir.x, lthing.y + dir.y, lthing.z + dir.z, lthing.value - 1)
			end
		end
end
