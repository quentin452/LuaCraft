function ExecuteCommand(command)
	if EnableCommandHUD == true then
		if command:sub(1, 3) == "/tp" then
			local x, y, z = command:match("/tp%s+([%d%.~-]+)%s+([%d%.~-]+)%s+([%d%.~-]+)")

			if x == "~" then
				x = ThePlayer.x
			else
				x = tonumber(x)
			end

			if y == "~" then
				y = WorldHeight
				while y > 0 and GetVoxel(ThePlayer.x, y, ThePlayer.z) == 0 do
					y = y - 1
				end
				y = y + 1.1
			else
				y = tonumber(y)
			end

			if z == "~" then
				z = ThePlayer.z
			else
				z = tonumber(z)
			end

			if x and y and z then
				ThePlayer.x = x
				ThePlayer.y = y
				ThePlayer.z = z
				LuaCraftPrintLoggingNormal("Player teleported to: " .. x .. ", " .. y .. ", " .. z)
			else
				LuaCraftPrintLoggingNormal("Invalid coordinates.")
			end
		else
			LuaCraftPrintLoggingNormal("Command executed: " .. command)
		end
	end
end
