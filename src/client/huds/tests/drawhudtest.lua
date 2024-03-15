local exampleModelReference = nil
function DrawTestBlock()
	if enableTESTBLOCK == false and modelalreadycreated == 1 then
		if exampleModelReference then
			-- Trouver l'indice du modèle dans la liste
			local modelIndex = nil
			for i, model in ipairs(scene.modelList) do
				if model == exampleModelReference then
					modelIndex = i
					break
				end
			end

			-- Retirer le modèle de la liste
			if modelIndex then
				table.remove(scene.modelList, modelIndex)
			end

			exampleModelReference = nil
			modelalreadycreated = 0
			LuaCraftPrintLoggingNormal("modelalreadycreated reset to 0")
		end
		LuaCraftPrintLoggingNormal("modelalreadycreated")
	elseif enableTESTBLOCK and modelalreadycreated == 0 then
		if modelalreadycreated == 1 then
			return
		end
		-- Example usage of engine.newModel
		local verts = {
			-- Face avant
			{ 0, 0, 0 },
			{ 1, 0, 0 },
			{ 1, 1, 0 },
			{ 1, 1, 0 },
			{ 0, 1, 0 },
			{ 0, 0, 0 },

			-- Face arrière
			{ 0, 0, 1 },
			{ 1, 0, 1 },
			{ 1, 1, 1 },
			{ 1, 1, 1 },
			{ 0, 1, 1 },
			{ 0, 0, 1 },

			-- Face gauche
			{ 0, 0, 0 },
			{ 0, 1, 0 },
			{ 0, 1, 1 },
			{ 0, 1, 1 },
			{ 0, 0, 1 },
			{ 0, 0, 0 },

			-- Face droite
			{ 1, 0, 0 },
			{ 1, 1, 0 },
			{ 1, 1, 1 },
			{ 1, 1, 1 },
			{ 1, 0, 1 },
			{ 1, 0, 0 },

			-- Face supérieure
			{ 0, 1, 0 },
			{ 1, 1, 0 },
			{ 1, 1, 1 },
			{ 1, 1, 1 },
			{ 0, 1, 1 },
			{ 0, 1, 0 },

			-- Face inférieure
			{ 0, 0, 0 },
			{ 1, 0, 0 },
			{ 1, 0, 1 },
			{ 1, 0, 1 },
			{ 0, 0, 1 },
			{ 0, 0, 0 },
		}
		local x = 0
		local y = 120
		local z = 0
		local coords = { x, y, z }
		local color = { 1, 1, 1 }
		local format = {
			{ "VertexPosition", "float", 3 },
			{ "VertexTexCoord", "float", 2 },
		}

		local t = NewThing(x, y, z)
		t.name = "BlockTest"

		myModel = engine.newModel(verts, BlockTest, coords, color, format)
		myModel.culling = false

		t:assignModel(myModel)

		exampleModelReference = myModel
		modelalreadycreated = 1
		LuaCraftPrintLoggingNormal("DrawTestBlock completed.")
	end
end