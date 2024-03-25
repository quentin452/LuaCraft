local temp = {}
local dirt = 4
local grass = true
local chunkfloor = 48
local maxHeight = 120
local scalar = 1.3
local waterlevel = 64
local tileID

--TODO REMOVE string.char USAGE IF POSSIBLE
function GenerateTerrain(chunk, x, z, generationFunction)
	_JPROFILER.push("GenerateTerrain")
	dirt = 4
	grass = true
	for i = 1, ChunkSize do
		_JPROFILER.push("ChunkSizeLoop")
		chunk.voxels[i] = Set()
		local xx = (x - 1) * ChunkSize + i
		for k = 1, ChunkSize do
			local zz = (z - 1) * ChunkSize + k
			chunk.heightMap[i][k] = 0
			local sunlight = true
			for j = WorldHeight, 1, -1 do
				_JPROFILER.push("WorldHeightLoop")
				local yy = (j - 1) * TileDataSize + 1
				local genFuncResult = generationFunction(chunk, xx, j, zz)
				for a = 1, TileDataSize - 1 do
					temp[yy + a] = string.char(LightSources[0])
				end
				if sunlight then
					temp[yy + 1] = string.char(LightSources[15])
				end
				if j == 1 then
					tileID = Tiles.BEDROCK_Block.id
				elseif j < chunkfloor then
					tileID = Tiles.STONE_Block.id
					sunlight = false
				elseif genFuncResult then
					if not grass and dirt > 0 then
						dirt = dirt - 1
						tileID = Tiles.DIRT_Block.id
					elseif not grass then
						tileID = Tiles.STONE_Block.id
					else
						grass = false
						tileID = Tiles.GRASS_Block.id
					end

					if sunlight then
						chunk.heightMap[i][k] = j
						sunlight = false
					end
				else
					grass = true
					dirt = 4
					tileID = Tiles.AIR_Block.id
				end
				temp[yy] = string.char(tileID)
				_JPROFILER.pop("WorldHeightLoop")
			end
			chunk.voxels[i][k] = table.concat(temp)
		end
		_JPROFILER.pop("ChunkSizeLoop")
	end
	temp = {}
	_JPROFILER.pop("GenerateTerrain")
end

function StandardTerrain(chunk, xx, j, zz)
	return ChunkNoise(xx, j, zz) > (j - chunkfloor) / (maxHeight - chunkfloor) * (Noise2D(xx, zz, 128, 5) * 0.75 + 0.75)
end
function ClassicTerrain(chunk, xx, j, zz)
	_JPROFILER.push("ClassicTerrain")

	local heightLow = (OctaveNoise(xx * scalar, zz * scalar, 8) + OctaveNoise(xx * scalar, zz * scalar, 8)) / 6 - 4
	local heightHigh = (OctaveNoise(xx * scalar, zz * scalar, 8) + OctaveNoise(xx * scalar, zz * scalar, 8)) / 5 - 6
	local heightResult = heightLow

	if OctaveNoise(xx, zz, 6) / 8 <= 0 then
		heightResult = math.max(heightLow, heightHigh)
	end

	heightResult = heightResult * 0.5
	if heightResult < 0 then
		heightResult = heightResult * 0.8
	end

	heightResult = heightResult + waterlevel
	_JPROFILER.pop("ClassicTerrain")

	return j <= heightResult --ChunkNoise(xx,j,zz) > (j-chunkfloor)/(maxHeight-chunkfloor)*(Noise2D(xx,zz, 128,5)*0.75 +0.75)
end

-- noise function used in chunk generation
function ChunkNoise(x, y, z)
	return Noise(x, y, z, 20, 12, 1)
end

function Noise(x, y, z, freq, yfreq)
	return love.math.noise(x / freq, y / yfreq, z / freq)
end

function Noise2D(x, z, freq)
	return love.math.noise(x / freq, z / freq)
end

function OctaveNoise(x, y, octaves)
	local ret = 0
	local freq = 1
	local amp = 1
	for _ = 1, octaves do
		ret = ret + love.math.noise(x * freq, y * freq) * amp - amp / 2
		freq = freq * 0.5
		amp = amp * 2
	end
	return ret
end
GlobalWorldType = StandardTerrain

WorldTypeMap = {
	[StandardTerrain] = { name = "Standard Terrain", nextType = ClassicTerrain },
	[ClassicTerrain] = { name = "Classic Terrain", nextType = StandardTerrain },
}
