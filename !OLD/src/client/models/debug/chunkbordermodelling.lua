local chunkBordersModels = {}
local function CreateChunkBordersVertices()
	ChunkVerts = {
		-- Bottom face
		{ 0, 0, 0 },
		{ ChunkSize, 0, 0 },
		{ ChunkSize, 0, ChunkSize },
		{ ChunkSize, 0, ChunkSize },
		{ 0, 0, ChunkSize },
		{ 0, 0, 0 },

		-- Top face
		{ 0, WorldHeight, 0 },
		{ ChunkSize, WorldHeight, 0 },
		{ ChunkSize, WorldHeight, ChunkSize },
		{ ChunkSize, WorldHeight, ChunkSize },
		{ 0, WorldHeight, ChunkSize },
		{ 0, WorldHeight, 0 },

		-- Front face
		{ 0, 0, 0 },
		{ ChunkSize, 0, 0 },
		{ ChunkSize, WorldHeight, 0 },
		{ ChunkSize, WorldHeight, 0 },
		{ 0, WorldHeight, 0 },
		{ 0, 0, 0 },

		-- Back face
		{ 0, 0, ChunkSize },
		{ ChunkSize, 0, ChunkSize },
		{ ChunkSize, WorldHeight, ChunkSize },
		{ ChunkSize, WorldHeight, ChunkSize },
		{ 0, WorldHeight, ChunkSize },
		{ 0, 0, ChunkSize },

		-- Left face
		{ 0, 0, 0 },
		{ 0, 0, ChunkSize },
		{ 0, WorldHeight, ChunkSize },
		{ 0, WorldHeight, ChunkSize },
		{ 0, WorldHeight, 0 },
		{ 0, 0, 0 },

		-- Right face
		{ ChunkSize, 0, 0 },
		{ ChunkSize, 0, ChunkSize },
		{ ChunkSize, WorldHeight, ChunkSize },
		{ ChunkSize, WorldHeight, ChunkSize },
		{ ChunkSize, WorldHeight, 0 },
		{ ChunkSize, 0, 0 },
	}
end
function DrawChunkBorders3D()
	if EnableF8 == false and ChunkBorderAlreadyCreated == 1 then
		for _, model in ipairs(chunkBordersModels) do
			local modelIndex = nil
			for i, sceneModel in ipairs(scene.modelList) do
				if sceneModel == model then
					modelIndex = i
					break
				end
			end

			if modelIndex then
				table.remove(scene.modelList, modelIndex)
			end
		end

		chunkBordersModels = {}

		ChunkBorderAlreadyCreated = 0
	elseif EnableF8 and ChunkBorderAlreadyCreated == 0 then
		for chunk, _ in pairs(ChunkSet) do
			if type(chunk) == "table" and chunk.x and chunk.y and chunk.z then
				CreateChunkBordersVertices()
				-- No rotation applied, so rotatedVerts is the same as verts
				local rotatedVerts = ChunkVerts

				-- Update verts with rotatedVerts
				ChunkVerts = rotatedVerts

				local x = (chunk.x - 1) * ChunkSize
				local y = chunk.y
				local z = (chunk.z - 1) * ChunkSize
				local coords = { x, y, z }
				local color = { 1, 1, 1 }
				local format = {
					{ "VertexPosition", "float", 3 },
					{ "VertexTexCoord", "float", 2 },
				}

				local t = NewThing(x, y, z)

				local chunkBordersModel = Engine.newModel(ChunkVerts, ChunkBorders, coords, color, format)
				chunkBordersModel.culling = false

				t:assignModel(chunkBordersModel)

				-- Ajouter le modèle à la table
				table.insert(chunkBordersModels, chunkBordersModel)
			end
		end

		ChunkBorderAlreadyCreated = 1
	end
end