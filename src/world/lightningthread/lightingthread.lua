LightingQueue = love.thread.newChannel()
LightingRemovalQueue = love.thread.newChannel()

function LightingUpdate()
	while true do
		local lthing = LightingRemovalQueue:pop()
		if lthing == nil then
			lthing = LightingQueue:pop()
			if lthing == nil then
				break
			end
		end

		if lthing.queryType == "NewSunlightSubtraction" then
			queryNewSunlightSubtraction(lthing)
		elseif lthing.queryType == "NewSunlightDownSubtraction" then
			queryNewSunlightDownSubtraction(lthing)
		elseif lthing.queryType == "NewLocalLightSubtraction" then
			queryNewLocalLightSubtraction(lthing)
		elseif lthing.queryType == "NewSunlightAddition" then
			queryNewSunlightAddition(lthing)
		elseif lthing.queryType == "NewSunlightDownAddition" then
			queryNewSunlightDownAddition(lthing)
		elseif lthing.queryType == "NewSunlightAdditionCreation" then
			queryNewSunlightAdditionCreation(lthing)
		elseif lthing.queryType == "NewSunlightForceAddition" then
			queryNewSunlightForceAddition(lthing)
		elseif lthing.queryType == "NewLocalLightAddition" then
			queryNewLocalLightAddition(lthing)
		elseif lthing.queryType == "NewLocalLightAdditionCreation" then
			queryNewLocalLightAdditionCreation(lthing)
		elseif lthing.queryType == "NewLocalLightForceAddition" then
			queryNewLocalLightForceAddition(lthing)
		end
	end
end
