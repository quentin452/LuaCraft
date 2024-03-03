function lerp(a, b, t)
	return (1 - t) * a + t * b
end
function math.angle(x1, y1, x2, y2)
	return math.atan2(y2 - y1, x2 - x1)
end
function math.dist(x1, y1, x2, y2)
	return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2) ^ 0.5
end
function math.dist3d(x1, y1, z1, x2, y2, z2)
	return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2) ^ 0.5
end

function choose(arr)
	return arr[math.floor(math.random() * #arr) + 1]
end
function rand(min, max, interval)
	local interval = interval or 1
	local c = {}
	local index = 1
	for i = min, max, interval do
		c[index] = i
		index = index + 1
	end

	return choose(c)
end
