function updateConfigFile(key, value)
	local fileContent, errorMessage = customReadFile(Luacraftconfig)
	if fileContent then
		fileContent = fileContent:gsub(key .. "=[%w]+", key .. "=" .. value)
		local file, err = io.open(Luacraftconfig, "w")
		if file then
			file:write(fileContent)
			file:close()
		else
			ThreadLogChannel:push({ LuaCraftLoggingLevel.ERROR, "Failed to open file for writing. Error: " .. err })
		end
	else
		ThreadLogChannel:push({
			LuaCraftLoggingLevel.ERROR,
			"Failed to read Luacraftconfig.txt. Error: " .. errorMessage,
		})
	end
end