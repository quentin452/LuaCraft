texturepathLuaCraft = "resources/assets/textures/"
blockandtilesfolderLuaCraft = "blocksandtiles"
blocktexturepathLuaCraft = blockandtilesfolderLuaCraft .. "/blocks/"
liquidtexturepathLuaCraft = blockandtilesfolderLuaCraft .. "/liquid/"
tilestexturepathLuaCraft = blockandtilesfolderLuaCraft .. "/tiles/"
function InitalizeTextureStatic()
	TilesTextureFORAtlasList = {}

	for _, tileData in pairs(Tiles) do
		if type(tileData) == "table" and tileData.id ~= 0 then
			TilesTextureFORAtlasList[tileData.id] = {}

			if tileData.blockTopTexture then
				table.insert(TilesTextureFORAtlasList[tileData.id], tileData.blockTopTexture)
			end

			if tileData.blockBottomMasterTexture then
				table.insert(TilesTextureFORAtlasList[tileData.id], tileData.blockBottomMasterTexture)
			end

			if tileData.blockSideTexture then
				table.insert(TilesTextureFORAtlasList[tileData.id], tileData.blockSideTexture)
			end
		elseif type(tileData) ~= "table" then
			TilesTextureFORAtlasList[tileData.id] = { tileData.blockBottomMasterTexture }
		end
	end
end
