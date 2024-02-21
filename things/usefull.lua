function drawColorString(Pstring, Px, Py)
	local rx = Px
	local ry = Py

	love.graphics.setColor(255, 255, 255) --white
	--local ignore is to remove the caracteres after the % on the rendering
	local ignore = 0
	for i = 1, string.len(Pstring) do
		if ignore == 0 then
			local c = string.sub(Pstring, i, i)

			if c == "%" then
				ignore = 1
				local color = string.sub(Pstring, i + 1, i + 1)
				if color == "3" then
					love.graphics.setColor(0, 255, 255) --blue
				else
					if color == "2" then
						love.graphics.setColor(0, 255, 0) --green
					else
						if color == "1" then
							love.graphics.setColor(255, 0, 0) --red
						else
							if color == "0" then
								love.graphics.setColor(255, 255, 255) --white
							end
						end
					end
				end
			else
				--render string without %
				love.graphics.print(c, rx, ry)
				--if i don't use rx = rx + _font:getWidth(c) all caracteres will be at same location
				rx = rx + _font:getWidth(c)
			end
		else
			ignore = ignore - 1
		end
	end
	-- love.graphics.print(Pstring,Px,Py)
end