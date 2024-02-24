globalRenderDistance = nil

globalVSync = love.window.getVSync()

local settingshandlingintialized = 0
function reloadConfig()
	if not love.filesystem.getInfo("config.conf") then
		return
	end

	local content, size = love.filesystem.read("config.conf")

	-- Mettez à jour globalVSync
    local vsyncValue = content:match("vsync=(%w+)")
    if vsyncValue then
        globalVSync = vsyncValue:lower() == "true"
        love.window.setVSync(globalVSync and 1 or 0)
    end

	-- Mettez à jour globalRenderDistance
	-- local renderdistanceValue = content:match("renderdistance=(%d)")
	-- if renderdistanceValue then
	--     globalRenderDistance = tonumber(renderdistanceValue)
	-- end

	-- Mettez à jour EnableLuaCraftPrints
	local printValue = content:match("luacraftprint=(%w+)")
	if printValue then
		EnableLuaCraftPrints = printValue:lower() == "true"
	end
end
function toggleVSync()
    globalVSync = not globalVSync
    love.window.setVSync(globalVSync and 1 or 0)

    -- Load current contents of config.conf file
    local content, size = love.filesystem.read("config.conf")

    -- Update vsync value in content
    content = content:gsub("vsync=%w+", "vsync=" .. (globalVSync and "true" or "false"))

    -- Rewrite config.conf file with updated content
    love.filesystem.write("config.conf", content)
end

function renderdistanceSetting()
	-- Load current contents of config.conf file
	local content, size = love.filesystem.read("config.conf")

	-- Increment the value of globalRenderDistance by 5
	globalRenderDistance = globalRenderDistance + 5

	-- Check if the value exceeds 25, reduce it to 5
	if globalRenderDistance > 25 then
		globalRenderDistance = 5
	end

	-- Update renderdistance value in content using regular expression
	content = content:gsub("renderdistance=(%d+)", "renderdistance=" .. globalRenderDistance)

	-- Rewrite config.conf file with updated content
	love.filesystem.write("config.conf", content)
end

function printSettings()
	EnableLuaCraftPrints = not EnableLuaCraftPrints

	-- Load current contents of config.conf file
	local content, size = love.filesystem.read("config.conf")

	-- Update print value in content
	local printValue = EnableLuaCraftPrints and "true" or "false"
	content = content:gsub("luacraftprint=%w+", "luacraftprint=" .. printValue)

	-- Rewrite config.conf file with updated content
	love.filesystem.write("config.conf", content)
end

function SettingsHandlingInit()
    reloadConfig()
    if globalRenderDistance == nil then
        -- Read the config file
        local content = love.filesystem.read("config.conf")

        -- Extract value
        local renderDistance = tonumber(content:match("renderdistance=(%d+)")) -- Make sure the key is lowercase "renderdistance"

        -- If no value in file, use default value
        if not renderDistance then
            renderDistance = 5
        end

        -- Set global variable
        globalRenderDistance = renderDistance
    end

    if love.filesystem.getInfo("config.conf") then
        local content, size = love.filesystem.read("config.conf")

        local vsyncValue = content:match("vsync=(%d)")
        if vsyncValue then
            love.window.setVSync(tonumber(vsyncValue))
        end

        local renderdistanceValue = content:match("renderdistance=(%d)")

        local printValue = content:match("luacraftprint=(%d)")

        if not renderdistanceValue then
            -- The renderdistance value does not exist, add the default value of 5
            renderdistanceValue = "5"

            -- Add the new line in the config.conf file only if it does not already exist
            if not content:match("renderdistance=") then
                content = content .. "\nrenderdistance=" .. renderdistanceValue

                -- Update config.conf file with new value
                love.filesystem.write("config.conf", content)
            end
        end

        if not vsyncValue then
            vsyncValue = 1
            if not content:match("vsync=") then
                content = content .. "\nvsync=" .. vsyncValue
                love.filesystem.write("config.conf", content)
            end
        end
        if not printValue then
            printValue = false
            if not content:match("luacraftprint=") then
                EnableLuaCraftPrints = false
                content = content .. "\nluacraftprint=" .. tostring(printValue)
                love.filesystem.write("config.conf", content)
            end
        end
    end
    settingshandlingintialized = 1
end
function getLuacraftPrintValue()
	if not love.filesystem.read("config.conf") and settingshandlingintialized == 0 then
		return
	end
	local content, size = love.filesystem.read("config.conf")
	print(content)
	return content:match("luacraftprint=(%d)")
end

EnableLuaCraftPrints = getLuacraftPrintValue()
function LuaCraftPrint(...)
	if EnableLuaCraftPrints then
		print(...)
	end
end
