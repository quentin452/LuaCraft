ThreadLightingChannel, LightOpe, LightingChannel, ThreadLogChannel, LuaCraftLoggingLevel = ...
local SIXDIRECTIONS = {
	{ x = 0, y = -1, z = 0 }, -- Down
	{ x = 0, y = 1, z = 0 }, -- Up
	{ x = 1, y = 0, z = 0 }, -- Right
	{ x = -1, y = 0, z = 0 }, -- Left
	{ x = 0, y = 0, z = 1 }, -- Forward
	{ x = 0, y = 0, z = -1 }, -- Backward
}

local LightingQueue = {}
local LightingRemovalQueue = {}

-- Function to add an item to the lighting queue
local function LightingQueueAdd(lthing)
	LightingQueue[#LightingQueue + 1] = lthing
	return lthing
end

-- Function to add an item to the lighting removal queue
local function LightingRemovalQueueAdd(lthing)
	LightingRemovalQueue[#LightingRemovalQueue + 1] = lthing
	return lthing
end

local function LightingUpdate()
	for _, lthing in ipairs(LightingRemovalQueue) do
		lthing:query()
	end
	for _, lthing in ipairs(LightingQueue) do
		lthing:query()
	end
	LightingRemovalQueue = {}
	LightingQueue = {}
end

local function LightningQueries(self, lightoperation)
	--local cget, cx, cy, cz = GetChunk(self.x, self.y, self.z)
	ThreadLightingChannel:push({ "GetChunk", self.x, self.y, self.z })
	local cget, cx, cy, cz = unpack(ThreadLightingChannel:demand())
	if cget == nil then
		return function() end
	end

	if lightoperation == LightOpe.SunForceAdd then
		return function()
			local val = cget:getVoxel(cx, cy, cz)
			if self.value >= 0 and TileLightable(val, true) then
				cget:setVoxelFirstData(cx, cy, cz, self.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = self.x + dir.x
					NewLightOperation(x, self.y + dir.y, self.z + dir.z, LightOpe.SunAdd, self.value - 1)
				end
			end
		end
	elseif lightoperation == LightOpe.SunCreationAdd then
		return function()
			local val = cget:getVoxel(cx, cy, cz)
			local dat = cget:getVoxelFirstData(cx, cy, cz)
			if TileLightable(val, true) and dat > 0 then
				NewLightOperation(self.x, self.y, self.z, LightOpe.SunForceAdd, dat)
			end
		end
	elseif lightoperation == LightOpe.SunDownAdd then
		return function()
			local val = cget:getVoxel(cx, cy, cz)
			local dat = cget:getVoxelFirstData(cx, cy, cz)
			if TileLightable(val) and dat <= self.value then
				cget:setVoxelFirstData(cx, cy, cz, self.value)
				NewLightOperation(self.x, self.y - 1, self.z, LightOpe.SunDownAdd, self.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = self.x + dir.x
					NewLightOperation(x, self.y + dir.y, self.z + dir.z, LightOpe.SunAdd, self.value - 1)
				end
			end
		end
	elseif lightoperation == LightOpe.LocalForceAdd then
		return function()
			local val, _, _ = cget:getVoxel(cx, cy, cz)
			if self.value >= 0 and TileLightable(val, true) then
				cget:setVoxelSecondData(cx, cy, cz, self.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = self.x + dir.x
					NewLightOperation(x, self.y + dir.y, self.z + dir.z, LightOpe.LocalAdd, self.value - 1)
				end
			end
		end
	elseif lightoperation == LightOpe.LocalSubtract then
		return function()
			local val, _ = cget:getVoxel(cx, cy, cz)
			local fget = cget:getVoxelSecondData(cx, cy, cz)
			if fget > 0 and self.value >= 0 and TileLightable(val, true) then
				if fget < self.value then
					cget:setVoxelSecondData(cx, cy, cz, 0)
					for _, dir in ipairs(SIXDIRECTIONS) do
						local nx, ny, nz = self.x + dir.x, self.y + dir.y, self.z + dir.z
						NewLightOperation(nx, ny, nz, LightOpe.LocalSubtract, fget)
					end
				else
					NewLightOperation(self.x, self.y, self.z, LightOpe.LocalForceAdd, fget)
				end
				return false
			end
		end
	elseif lightoperation == LightOpe.LocalCreationAdd then
		return function()
			local val, _, dat = cget:getVoxel(cx, cy, cz)
			if TileLightable(val, true) and dat > 0 then
				NewLightOperation(self.x, self.y, self.z, LightOpe.LocalForceAdd, dat)
			end
		end
	elseif lightoperation == LightOpe.SunAdd then
		return function()
			local val = cget:getVoxel(cx, cy, cz)
			local dat = cget:getVoxelFirstData(cx, cy, cz)
			if self.value >= 0 and TileLightable(val, true) and dat < self.value then
				cget:setVoxelFirstData(cx, cy, cz, self.value)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = self.x + dir.x
					NewLightOperation(x, self.y + dir.y, self.z + dir.z, LightOpe.SunAdd, self.value - 1)
				end
			end
		end
	elseif lightoperation == LightOpe.LocalAdd then
		return function()
			local localcx, localcy, localcz = Localize(self.x, self.y, self.z)
			local val, _, dat = cget:getVoxel(localcx, localcy, localcz)
			if TileLightable(val, true) and dat < self.value then
				cget:setVoxelSecondData(localcx, localcy, localcz, self.value)
				if self.value > 1 then
					for _, dir in ipairs(SIXDIRECTIONS) do
						local x = self.x + dir.x
						NewLightOperation(x, self.y + dir.y, self.z + dir.z, LightOpe.LocalAdd, self.value - 1)
					end
				end
			end
		end
	elseif lightoperation == LightOpe.SunSubtract then
		return function()
			local val = cget:getVoxel(cx, cy, cz)
			local fget = cget:getVoxelFirstData(cx, cy, cz)
			if fget > 0 and self.value >= 0 and TileLightable(val, true) then
				if fget < self.value then
					cget:setVoxelFirstData(cx, cy, cz, Tiles.AIR_Block.id)
					for _, dir in ipairs(SIXDIRECTIONS) do
						local x = self.x + dir.x
						NewLightOperation(x, self.y + dir.y, self.z + dir.z, LightOpe.SunSubtract, fget)
					end
				else
					NewLightOperation(self.x, self.y, self.z, LightOpe.SunForceAdd, fget)
				end
				return false
			end
		end
	elseif lightoperation == LightOpe.SunDownSubtract then
		return function()
			if TileLightable(GetVoxel(self.x, self.y, self.z), true) then
				SetVoxelFirstData(self.x, self.y, self.z, Tiles.AIR_Block.id)
				NewLightOperation(self.x, self.y - 1, self.z, LightOpe.SunDownSubtract)
				for _, dir in ipairs(SIXDIRECTIONS) do
					local x = self.x + dir.x
					NewLightOperation(x, self.y + dir.y, self.z + dir.z, LightOpe.SunSubtract, LightSources[15])
				end
				return true
			end
		end
	end
end
local operationFunctions = {
	[LightOpe.SunForceAdd] = LightingQueueAdd,
	[LightOpe.SunCreationAdd] = LightingQueueAdd,
	[LightOpe.SunDownAdd] = LightingQueueAdd,
	[LightOpe.LocalForceAdd] = LightingQueueAdd,
	[LightOpe.LocalCreationAdd] = LightingQueueAdd,
	[LightOpe.SunAdd] = LightingQueueAdd,
	[LightOpe.LocalAdd] = LightingQueueAdd,
	[LightOpe.LocalSubtract] = LightingRemovalQueueAdd,
	[LightOpe.SunSubtract] = LightingRemovalQueueAdd,
	[LightOpe.SunDownSubtract] = LightingRemovalQueueAdd,
}

function NewLightOperation(x, y, z, lightoperation, value)
	local t = { x = x, y = y, z = z, value = value }
	t.query = LightningQueries(t, lightoperation)
	local operationFunction = operationFunctions[lightoperation]
	if operationFunction then
		operationFunction(t)
	else
		ThreadLogChannel:push({
			LuaCraftLoggingLevel.ERROR,
			"This lightoperation: " .. lightoperation .. " is not correct",
		})
	end
end

while true do
	print("Entrée de la boucle") -- Ajout d'un print pour marquer le début de chaque itération de la boucle
	local message1 = ThreadLightingChannel:demand()
	if message1 then
		local action = message1[1]
		if action == "LightOperation" then
			local x, y, z, lightoperation, value = unpack(message1, 2)
			NewLightOperation(x, y, z, lightoperation, value)
			print("Message 1 traité avec succès")
			print("test2")
		end
		if action == "GetChunk" then
			local x, y, z = message1[2], message1[3], message1[4]
			ThreadLightingChannel:push({ "GetChunk", x, y, z })
			local response = ThreadLightingChannel:demand()
			if response then
				local cget, cx, cy, cz, hashx, hashy = unpack(response)
				ThreadLightingChannel:push({ cget, cx, cy, cz, hashx, hashy })
				print("Chunk demandé et envoyé au canal ThreadLightingChannel") -- Print indiquant que le chunk a été demandé et envoyé
			else
				print("Aucune réponse reçue du canal ThreadLightingChannel")
			end
		end
		if action == "updateLighting" then
			LightingUpdate()
			print("Canal d'éclairage mis à jour")
		end
	end
	print("Fin de l'itération de la boucle") -- Ajout d'un print pour marquer la fin de chaque itération de la boucle
end