Settings = {}

function checkAndUpdateDefaults(Settings)
	if Settings["vsync"] == nil then
		Settings["vsync"] = true
	end
	if Settings["LuaCraftPrintLoggingNormal"] == nil then
		Settings["LuaCraftPrintLoggingNormal"] = true
	end
	if Settings["LuaCraftWarnLogging"] == nil then
		Settings["LuaCraftWarnLogging"] = true
	end
	if Settings["LuaCraftErrorLogging"] == nil then
		Settings["LuaCraftErrorLogging"] = true
	end
	if Settings["renderdistance"] == nil then
		Settings["renderdistance"] = 5
	end
end

function customReadFile(filePath)
	local file, error_message = io.open(filePath, "r")

	if file then
		local content = file:read("*a") -- *a read all things in the configurations
		file:close()
		return content
	else
		return nil, error_message
	end
end

function loadAndSaveLuaCraftFileSystem()
	LuaCraftPrintLoggingNormal("Attempting to load LuaCraft settings")

	local userDirectory = love.filesystem.getUserDirectory()
	local luaCraftDirectory = userDirectory .. ".LuaCraft\\"
	local configFilePath = luaCraftDirectory .. "luacraftconfig.txt"

	LuaCraftPrintLoggingNormal("Directory contents before attempting to load settings:")
	for _, item in ipairs(love.filesystem.getDirectoryItems(luaCraftDirectory)) do
		LuaCraftPrintLoggingNormal(item)
	end

	LuaCraftPrintLoggingNormal("Config file path: " .. configFilePath)

	local file_content, error_message = customReadFile(configFilePath)

	if file_content then
		local Settings = {}
		local orderedKeys = { "vsync", "LuaCraftPrintLoggingNormal", "LuaCraftWarnLogging","LuaCraftErrorLogging", "renderdistance" }

		for _, key in ipairs(orderedKeys) do
			local value = file_content:match(key .. "=(%w+)")
			if value then
				local numValue = tonumber(value)
				Settings[key] = numValue or (value == "true")
			end
		end

		LuaCraftPrintLoggingNormal("Settings loaded successfully.")

		-- Verify and Update Default Values
		checkAndUpdateDefaults(Settings)

		-- Open the file in Writter mod
		local file, error_message = io.open(configFilePath, "w")

		if file then
			-- Write parameters with verifications
			for _, key in ipairs(orderedKeys) do
				file:write(key .. "=" .. tostring(Settings[key]) .. "\n")
			end

			file:close()
			LuaCraftPrintLoggingNormal("Settings loaded and saved to luacraftconfig.txt")
		else
			LuaCraftErrorLogging("Failed to open file for writing. Error: " .. error_message)
		end
	else
		LuaCraftErrorLogging("Failed to open file for reading. Error: " .. error_message)
	end
end
