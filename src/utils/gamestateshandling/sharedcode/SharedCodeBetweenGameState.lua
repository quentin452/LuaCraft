local menuWidth = 0

function SharedSettingsResizeMenu(choice)
	local newMenuWidth = 0
	for _, choice in ipairs(choice) do
		local choiceWidth = LuaCraftCurrentGameState:setFont():getWidth(choice)
		if choiceWidth > newMenuWidth then
			newMenuWidth = choiceWidth
		end
	end
	menuWidth = newMenuWidth
end
function SharedSelectionMenuBetweenGameState(x, y, b, choice, selection, menuactionfunc)
	if b == 1 then
		local w, h = Lovegraphics.getDimensions()
		local posX = w * 0.4
		local posY = h * 0.4
		local lineHeight = GetSelectedFont():getHeight("X")
		local choiceClicked = math.floor((y - posY) / lineHeight)
		local minX = posX
		local maxX = posX + menuWidth
		if choiceClicked >= 1 and choiceClicked <= #choice and x >= minX and x <= maxX then
			selection = choiceClicked
			menuactionfunc(selection)
		end
	end
	return choice, selection
end
function SharedSelectionKeyPressedBetweenGameState(k, choice, selection, menuactionfunc)
	if ConfiguringMovementKey_KeyPressed == false then
		if k == BackWardKey then
			if selection < #choice then
				selection = selection + 1
			end
		elseif k == ForWardKey then
			if selection > 1 then
				selection = selection - 1
			end
		elseif k == "return" then
			menuactionfunc(selection)
		end
	end
	return choice, selection
end
