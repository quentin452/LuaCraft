--ytb tutorial : https://www.youtube.com/watch?v=0CSfM76u9yM

--main thread code
--[[function calc_squares()
	for i = 1, 100000 do
		print(i * i)
	end
end
]]
--separate thread code
local threadCode = [[
for i = 1, 100000 do
	print(i * i)
end
]]

function create_Test_Thread()
	local thread = love.thread.newThread(threadCode)
	thread:start()
end
