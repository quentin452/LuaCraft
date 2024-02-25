function UpdateGame(dt)
    LogicAccumulator = LogicAccumulator + dt

	-- update all things in ThingList update queue
	local i = 1
	while i <= #ThingList do
		local thing = ThingList[i]
		if thing:update(dt) then
			i = i + 1
		else
			table.remove(ThingList, i)
			thing:destroy()
			thing:destroyModel()
		end
	end

	-- update 3D scene with dt only if PhysicsStep is true
	if PhysicsStep then
		Scene:update()
	end

	local logicThreshold = 1 / 60

	local fps = love.timer.getFPS()

	if LogicAccumulator >= logicThreshold and fps ~= 0 then
		local logicUpdates = math.floor(LogicAccumulator / logicThreshold)
		LogicAccumulator = LogicAccumulator - logicThreshold * logicUpdates
		PhysicsStep = true
	else
		PhysicsStep = false
	end
end