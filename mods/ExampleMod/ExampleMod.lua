--dependencies (if you had error caused by something like attempt to index global nil then try to add deps)
require("src/modloader/modloaderinit")
--mod dependencies (here you should add all lua of your mod here to don't had problems during initialize)
require("mods/ExampleMod/structures/generatestructures")
require("mods/ExampleMod/structures/generatetree")

local ExampleMod = {}

function ExampleMod.initialize()
	addFunctionToTag("chunkPopulateTag", function(self, i, height, j)
		local xx = (self.x - 1) * ChunkSize + i
		local zz = (self.z - 1) * ChunkSize + j
		--generate Trees
		if love.math.random() < love.math.noise(xx / 64, zz / 64) * 0.02 then
			ExampleMod_GenerateTree(self, i, height, j)
			self:setVoxelRaw(i, height, j, __DIRT_Block, 15)
		end
	end)
	addFunctionToTag("chunkPopulateTag", function(self, i, height, j)
		local xx = (self.x - 1) * ChunkSize + i
		local zz = (self.z - 1) * ChunkSize + j
		--generate flowers YELLOW/ROSE
		if love.math.noise(xx / 32, zz / 32) > 0.9 and love.math.random() < 0.2 then
			local flowerID = love.math.random(__YELLO_FLOWER_Block, __ROSE_FLOWER_Block)
			self:setVoxelRaw(i, height + 1, j, flowerID, 15)
		end
	end)
end

return ExampleMod