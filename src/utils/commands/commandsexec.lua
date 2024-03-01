function ExecuteCommand(command)
	if enableCommandHUD == true then
		if command:sub(1, 3) == "/tp" then
			local x, y, z = command:match("/tp (%-?%d+%.?%d*) (%-?%d+%.?%d*) (%-?%d+%.?%d*)")
			x = tonumber(x)
			y = tonumber(y)
			z = tonumber(z)

			if x and y and z then
				ThePlayer.x = x
				ThePlayer.y = y
				ThePlayer.z = z
				LuaCraftPrintLoggingNormal("Player teleported to: " .. x .. ", " .. y .. ", " .. z)
				for _, chunk in ipairs(renderChunks) do
					for i = 1, #chunk.slices do
						local chunkSlice = chunk.slices[i]
						chunkSlice:destroy()
						chunkSlice:destroyModel()
						chunkSlice.enableBlockAndTilesModels = false
						chunk.slices[i] = nil
					end
				end
			else
				LuaCraftPrintLoggingNormal("Invalid coordinates.")
			end
		else
			LuaCraftPrintLoggingNormal("Command executed: " .. command)
		end
	end
end
