require("src/utils/filesystem")

globalVSync = lovewindow.getVSync()

function reloadConfig()
	local file_content, error_message = customReadFile(luacraftconfig)
	if file_content then
		local vsyncValue = file_content:match("vsync=(%w+)")
		if vsyncValue then
			globalVSync = vsyncValue:lower() == "true"
			lovewindow.setVSync(globalVSync and 1 or 0)
		end

		--	local renderdistanceValue = file_content:match("renderdistance=(%d+)")
		--	globalRenderDistance = tonumber(renderdistanceValue) or 6

		local printNormalValue = file_content:match("LuaCraftPrintLoggingNormal=(%w+)")
		EnableLuaCraftPrintLoggingNormalLogging = printNormalValue:lower() == "true"

		local warnValue = file_content:match("LuaCraftWarnLogging=(%w+)")
		EnableLuaCraftLoggingWarn = warnValue:lower() == "true"

		local errorValue = file_content:match("LuaCraftErrorLogging=(%w+)")
		EnableLuaCraftLoggingError = errorValue:lower() == "true"
	else
		LuaCraftErrorLogging("Failed to read luacraftconfig.txt. Error: " .. error_message)
	end
end

function toggleFullScreen()
	_JPROFILER.push("toggleFullScreen")
	GlobalFullscreen = not GlobalFullscreen

	local fullscreenSetting = GlobalFullscreen and "true" or "false"

	-- Update the configuration file
	local file_content, error_message = customReadFile(luacraftconfig)

	if file_content then
		file_content = file_content:gsub("fullscreen=%w+", "fullscreen=" .. fullscreenSetting)

		local file, error_message = io.open(luacraftconfig, "w")

		if file then
			file:write(file_content)
			file:close()
		else
			LuaCraftErrorLogging("Failed to open file for writing. Error: " .. error_message)
		end
	else
		LuaCraftErrorLogging("Failed to read luacraftconfig.txt. Error: " .. error_message)
	end

	-- Set the window to fullscreen
	local fullscreen = GlobalFullscreen
	local fullscreenType = "desktop" -- Can be "desktop" or "exclusive"
	love.window.setFullscreen(fullscreen, fullscreenType)

	_JPROFILER.pop("toggleFullScreen")
end

function toggleVSync()
	_JPROFILER.push("toggleVSync")
	globalVSync = not globalVSync
	lovewindow.setVSync(globalVSync and 1 or 0)

	local file_content, error_message = customReadFile(luacraftconfig)

	if file_content then
		file_content = file_content:gsub("vsync=%w+", "vsync=" .. (globalVSync and "true" or "false"))
		local file, error_message = io.open(luacraftconfig, "w")
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

function getRenderDistanceValue()
	local file_content, error_message = customReadFile(luacraftconfig)

	if file_content then
		local current_renderdistance = tonumber(file_content:match("renderdistance=(%d+)")) or 6
		return current_renderdistance * 16 --ChunkSize
	else
		LuaCraftErrorLogging("Failed to read luacraftconfig.txt. Error: " .. error_message)
		return
	end
end

function renderdistanceSetting()
	local file_content, error_message = customReadFile(luacraftconfig)

	if file_content then
		local current_renderdistance = tonumber(file_content:match("renderdistance=(%d+)")) or 0
		globalRenderDistance = current_renderdistance + 2

		if globalRenderDistance > 20 then
			globalRenderDistance = 2
		end

		file_content = file_content:gsub("renderdistance=(%d+)", "renderdistance=" .. globalRenderDistance)

		local file, error_message = io.open(luacraftconfig, "w")
		if file then
			file:write(file_content)
			file:close()
		else
			LuaCraftErrorLogging("Failed to open file for writing. Error: " .. error_message)
		end
	else
		LuaCraftErrorLogging("Failed to read luacraftconfig.txt. Error: " .. error_message)
	end
	return globalRenderDistance
end

function printNormalLoggingSettings()
	_JPROFILER.push("printNormalLoggingSettings")
	EnableLuaCraftPrintLoggingNormalLogging = not EnableLuaCraftPrintLoggingNormalLogging
	-- Load current contents of luacraftconfig.txt file
	local file_content, error_message = customReadFile(luacraftconfig)

	if file_content then
		-- Update print value in content
		local printValue = EnableLuaCraftPrintLoggingNormalLogging and "true" or "false"
		file_content = file_content:gsub("LuaCraftPrintLoggingNormal=%w+", "LuaCraftPrintLoggingNormal=" .. printValue)

		-- Rewrite luacraftconfig.txt file with updated content
		local file, error_message = io.open(luacraftconfig, "w")
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

	local file_content, error_message = customReadFile(luacraftconfig)

	if file_content then
		-- Update print value in content
		local printValue = EnableLuaCraftLoggingWarn and "true" or "false"
		file_content = file_content:gsub("LuaCraftWarnLogging=%w+", "LuaCraftWarnLogging=" .. printValue)

		-- Rewrite luacraftconfig.txt file with updated content
		local file, error_message = io.open(luacraftconfig, "w")
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

	local file_content, error_message = customReadFile(luacraftconfig)

	if file_content then
		-- Update print value in content
		local printValue = EnableLuaCraftLoggingError and "true" or "false"
		file_content = file_content:gsub("LuaCraftErrorLogging=%w+", "LuaCraftErrorLogging=" .. printValue)

		-- Rewrite luacraftconfig.txt file with updated content
		local file, error_message = io.open(luacraftconfig, "w")
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

	reloadConfig()
	local file_content, error_message = customReadFile(luacraftconfig)
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
