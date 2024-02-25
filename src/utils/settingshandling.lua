require("src/utils/filesystem")

globalVSync = lovewindow.getVSync()

local function reloadConfig()
	_JPROFILER.push("reloadConfig")
	local file_content, error_message = customReadFile("C:\\Users\\iamacatfr\\.LuaCraft\\luacraftconfig.txt")
	if file_content then
		local vsyncValue = file_content:match("vsync=(%w+)")
		if vsyncValue then
			globalVSync = vsyncValue:lower() == "true"
			lovewindow.setVSync(globalVSync and 1 or 0)
		end

		-- local renderdistanceValue = file_content:match("renderdistance=(%d+)")
		-- globalRenderDistance = tonumber(renderdistanceValue) or 5

		local printNormalValue = file_content:match("LuaCraftPrintLoggingNormal=(%w+)")
		EnableLuaCraftPrintLoggingNormalLogging = printNormalValue:lower() == "true"

		local warnValue = file_content:match("LuaCraftWarnLogging=(%w+)")
		EnableLuaCraftLoggingWarn = warnValue:lower() == "true"

		local errorValue = file_content:match("LuaCraftErrorLogging=(%w+)")
		EnableLuaCraftLoggingError = errorValue:lower() == "true"
	else
		LuaCraftErrorLogging("Failed to read luacraftconfig.txt. Error: " .. error_message)
	end
	_JPROFILER.pop("reloadConfig")
end

function toggleVSync()
	_JPROFILER.push("toggleVSync")
	globalVSync = not globalVSync
	lovewindow.setVSync(globalVSync and 1 or 0)

	local file_content, error_message = customReadFile("C:\\Users\\iamacatfr\\.LuaCraft\\luacraftconfig.txt")

	if file_content then
		file_content = file_content:gsub("vsync=%w+", "vsync=" .. (globalVSync and "true" or "false"))

		local file, error_message = io.open("C:\\Users\\iamacatfr\\.LuaCraft\\luacraftconfig.txt", "w")
		if file then
			file:write(file_content)
			file:close()
		else
			LuaCraftErrorLogging("Failed to open file for writing. Error: " .. error_message)
		end
	else
		LuaCraftErrorLogging("Failed to read luacraftconfig.txt. Error: " .. error_message)
	end
	_JPROFILER.pop("toggleVSync")
end
function refreshRenderDistance()
	_JPROFILER.push("refreshRenderDistance")
	local file_path = "C:\\Users\\iamacatfr\\.LuaCraft\\luacraftconfig.txt"

	local file_content, error_message = customReadFile(file_path)

	if file_content then
		local current_renderdistance = tonumber(file_content:match("renderdistance=(%d+)")) or 0
		globalRenderDistance = current_renderdistance
		file_content = file_content:gsub("renderdistance=(%d+)", "renderdistance=" .. globalRenderDistance)
		local file, error_message = io.open(file_path, "w")
		if file then
			file:write(file_content)
			file:close()
			LuaCraftPrintLoggingNormal("Render distance refreshed successfully.")
		else
			LuaCraftErrorLogging("Failed to open file for writing. Error: " .. error_message)
		end
	else
		LuaCraftErrorLogging("Failed to read luacraftconfig.txt. Error: " .. error_message)
	end
	_JPROFILER.pop("refreshRenderDistance")
end

function renderdistanceSetting()
	_JPROFILER.push("renderdistanceSetting")
	local file_path = "C:\\Users\\iamacatfr\\.LuaCraft\\luacraftconfig.txt"
	local file_content, error_message = customReadFile(file_path)

	if file_content then
		local current_renderdistance = tonumber(file_content:match("renderdistance=(%d+)")) or 0
		globalRenderDistance = current_renderdistance + 5

		if globalRenderDistance > 25 then
			globalRenderDistance = 5
		end

		file_content = file_content:gsub("renderdistance=(%d+)", "renderdistance=" .. globalRenderDistance)

		local file, error_message = io.open(file_path, "w")
		if file then
			file:write(file_content)
			file:close()
		else
			LuaCraftErrorLogging("Failed to open file for writing. Error: " .. error_message)
		end
	else
		LuaCraftErrorLogging("Failed to read luacraftconfig.txt. Error: " .. error_message)
	end
	_JPROFILER.pop("renderdistanceSetting")
end

function printNormalLoggingSettings()
	_JPROFILER.push("printNormalLoggingSettings")
	EnableLuaCraftPrintLoggingNormalLogging = not EnableLuaCraftPrintLoggingNormalLogging
	-- Load current contents of luacraftconfig.txt file
	local file_content, error_message = customReadFile("C:\\Users\\iamacatfr\\.LuaCraft\\luacraftconfig.txt")

	if file_content then
		-- Update print value in content
		local printValue = EnableLuaCraftPrintLoggingNormalLogging and "true" or "false"
		file_content = file_content:gsub("LuaCraftPrintLoggingNormal=%w+", "LuaCraftPrintLoggingNormal=" .. printValue)

		-- Rewrite luacraftconfig.txt file with updated content
		local file, error_message = io.open("C:\\Users\\iamacatfr\\.LuaCraft\\luacraftconfig.txt", "w")
		if file then
			file:write(file_content)
			file:close()
		else
			LuaCraftErrorLogging("Failed to open file for writing. Error: " .. error_message)
		end
	else
		LuaCraftErrorLogging("Failed to read luacraftconfig.txt. Error: " .. error_message)
	end
	_JPROFILER.pop("printNormalLoggingSettings")
end
function printWarnsSettings()
	_JPROFILER.push("printWarnsSettings")
	EnableLuaCraftLoggingWarn = not EnableLuaCraftLoggingWarn
	-- Load current contents of luacraftconfig.txt file
	local file_content, error_message = customReadFile("C:\\Users\\iamacatfr\\.LuaCraft\\luacraftconfig.txt")

	if file_content then
		-- Update print value in content
		local printValue = EnableLuaCraftLoggingWarn and "true" or "false"
		file_content = file_content:gsub("LuaCraftWarnLogging=%w+", "LuaCraftWarnLogging=" .. printValue)

		-- Rewrite luacraftconfig.txt file with updated content
		local file, error_message = io.open("C:\\Users\\iamacatfr\\.LuaCraft\\luacraftconfig.txt", "w")
		if file then
			file:write(file_content)
			file:close()
		else
			LuaCraftErrorLogging("Failed to open file for writing. Error: " .. error_message)
		end
	else
		LuaCraftErrorLogging("Failed to read luacraftconfig.txt. Error: " .. error_message)
	end
	_JPROFILER.pop("printWarnsSettings")
end
function printErrorsSettings()
	_JPROFILER.push("printErrorsSettings")

	EnableLuaCraftLoggingError = not EnableLuaCraftLoggingError

	-- Load current contents of luacraftconfig.txt file
	local file_content, error_message = customReadFile("C:\\Users\\iamacatfr\\.LuaCraft\\luacraftconfig.txt")

	if file_content then
		-- Update print value in content
		local printValue = EnableLuaCraftLoggingError and "true" or "false"
		file_content = file_content:gsub("LuaCraftErrorLogging=%w+", "LuaCraftErrorLogging=" .. printValue)

		-- Rewrite luacraftconfig.txt file with updated content
		local file, error_message = io.open("C:\\Users\\iamacatfr\\.LuaCraft\\luacraftconfig.txt", "w")
		if file then
			file:write(file_content)
			file:close()
		else
			LuaCraftErrorLogging("Failed to open file for writing. Error: " .. error_message)
		end
	else
		LuaCraftErrorLogging("Failed to read luacraftconfig.txt. Error: " .. error_message)
	end
	_JPROFILER.pop("printErrorsSettings")
end

function createDefaultConfig(filePath)
	local defaultContent =
		"vsync=true\nLuaCraftPrintLoggingNormal=false\nLuaCraftWarnLogging=false\nLuaCraftErrorLogging=false\nrenderdistance=5"

	local file, error_message = io.open(filePath, "w")
	if file then
		file:write(defaultContent)
		file:close()
		print("Created default luacraftconfig.txt")
	else
		LuaCraftErrorLogging("Failed to create default luacraftconfig.txt. Error: " .. error_message)
	end
end
function SettingsHandlingInit()
	_JPROFILER.push("SettingsHandlingInit")

	local configFilePath = "C:\\Users\\iamacatfr\\.LuaCraft\\luacraftconfig.txt"

	if love.filesystem.getInfo(configFilePath) == nil then
		loadAndSaveLuaCraftFileSystem()
	end
	reloadConfig()

	local file_content, error_message = customReadFile("C:\\Users\\iamacatfr\\.LuaCraft\\luacraftconfig.txt")
	if file_content then
		local vsyncValue = file_content:match("vsync=(%d)")
		if vsyncValue then
			lovewindow.setVSync(tonumber(vsyncValue))
		end

		local renderdistanceValue = file_content:match("renderdistance=(%d)")
		globalRenderDistance = tonumber(renderdistanceValue)
	else
		LuaCraftErrorLogging("Failed to read luacraftconfig.txt. Error: " .. error_message)
	end
	_JPROFILER.pop("SettingsHandlingInit")
end

function getLuaCraftPrintLoggingNormalValue()
	local file_content, error_message = customReadFile("C:\\Users\\iamacatfr\\.LuaCraft\\luacraftconfig.txt")
	return file_content and file_content:match("LuaCraftPrintLoggingNormal=(%d)")
end

function getLuaCraftPrintLoggingWarnValue()
	local file_content, error_message = customReadFile("C:\\Users\\iamacatfr\\.LuaCraft\\luacraftconfig.txt")
	return file_content and file_content:match("LuaCraftWarnLogging=(%d)")
end

function getLuaCraftPrintLoggingErrorValue()
	local file_content, error_message = customReadFile("C:\\Users\\iamacatfr\\.LuaCraft\\luacraftconfig.txt")
	return file_content and file_content:match("LuaCraftErrorLogging=(%d)")
end

EnableLuaCraftPrintLoggingNormalLogging = getLuaCraftPrintLoggingNormalValue()

function LuaCraftPrintLoggingNormal(...)
	if EnableLuaCraftPrintLoggingNormalLogging then
		print("[NORMAL LOGGING]", ...)
	end
end

EnableLuaCraftLoggingWarn = getLuaCraftPrintLoggingWarnValue()

function LuaCraftWarnLogging(...)
	if EnableLuaCraftLoggingWarn then
		print("[WARN]", ...)
	end
end

EnableLuaCraftLoggingError = getLuaCraftPrintLoggingErrorValue()

function LuaCraftErrorLogging(...)
	if EnableLuaCraftLoggingError then
		error(...)
	end
end
