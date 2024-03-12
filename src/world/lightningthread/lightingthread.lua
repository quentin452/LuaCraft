LightingQueue = love.thread.newChannel()
LightingRemovalQueue = love.thread.newChannel()

local queryHandlers = {
	["NewSunlightSubtraction"] = queryNewSunlightSubtraction,
	["NewSunlightDownSubtraction"] = queryNewSunlightDownSubtraction,
	["NewLocalLightSubtraction"] = queryNewLocalLightSubtraction,
	["NewSunlightAddition"] = queryNewSunlightAddition,
	["NewSunlightDownAddition"] = queryNewSunlightDownAddition,
	["NewSunlightAdditionCreation"] = queryNewSunlightAdditionCreation,
	["NewSunlightForceAddition"] = queryNewSunlightForceAddition,
	["NewLocalLightAddition"] = queryNewLocalLightAddition,
	["NewLocalLightAdditionCreation"] = queryNewLocalLightAdditionCreation,
	["NewLocalLightForceAddition"] = queryNewLocalLightForceAddition,
}

function LightingUpdate()
	_JPROFILER.push("LightingUpdate_LightingThread")
	while true do
		local lthing = LightingRemovalQueue:pop()
		if lthing == nil then
			lthing = LightingQueue:pop()
			if lthing == nil then
				break
			end
		end

		local handler = queryHandlers[lthing.queryType]
		if handler then
			handler(lthing)
		end
	end
	_JPROFILER.pop("LightingUpdate_LightingThread")
end
