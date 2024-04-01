function CreateThing(thing)
	table.insert(ThingList, thing)
	return thing
end

-- create parent class for all thing objects stored in ThingList
function NewThing(x, y, z)
	local t = {}
	t.x = x
	t.y = y
	t.z = z
	t.xSpeed = 0
	t.ySpeed = 0
	t.zSpeed = 0
	t.modelID = -1
	t.model = nil
	t.direction = 0
	t.assignedModel = 0

	t.update = function(self, dt)
		return true
	end

	t.assignModel = function(self, model)
		self.model = model

		if self.assignedModel == 0 then
			table.insert(Scene.modelList, self.model)
			self.assignedModel = #Scene.modelList
		else
			Scene.modelList[self.assignedModel] = self.model
		end
	end

	t.destroyModel = function(self)
		self.model.dead = true
	end

	t.destroy = function(self) end

	t.mousepressed = function(self, b) end

	--UNTESTED CODE	
	t.distanceToThing = function(self, thing, radius, ignorey)
		for i = 1, #ThingList do
			local this = ThingList[i]
			local distcheck = math.dist3d(this.x, this.y, this.z, self.x, self.y, self.z) < radius

			if ignorey then
				distcheck = math.dist3d(this.x, 0, this.z, self.x, 0, self.z) < radius
			end

			if this.model == thing and this ~= self and distcheck then
				return this
			end
			
		end

		return nil
	end

	return t
end

-- a parent class for a 2d sprite billboard 3d object
--TODO
function NewBillboard(x, y, z)
	local t = NewThing(x, y, z)
	local verts = {}
	local scale = 6
	local hs = scale / 2
	verts[#verts + 1] = { 0, 0, hs, 1, 1 }
	verts[#verts + 1] = { 0, 0, -hs, 0, 1 }
	verts[#verts + 1] = { 0, scale, hs, 1, 0 }

	verts[#verts + 1] = { 0, 0, -hs, 0, 1 }
	verts[#verts + 1] = { 0, scale, -hs, 0, 0 }
	verts[#verts + 1] = { 0, scale, hs, 1, 0 }

	texture = love.graphics.newImage("/textures/enemy1.png")
	local model = Engine.newModel(Engine.luaModelLoader(verts), DefaultTexture, { 0, 0, 0 })
	model.lightable = false
	t:assignModel(model)

	t.direction = 0

	t.update = function(self, dt)
		self.direction = -1 * Scene.camera.angle.x + math.pi / 2
		self.model:setTransform({ self.x, self.y, self.z }, { self.direction, Cpml.vec3.unit_y })
		return true
	end

	return t
end

function table_print(tt, indent, done)
	done = done or {}
	indent = indent or 0
	if type(tt) == "table" then
		local sb = {}
		for key, value in pairs(tt) do
			table.insert(sb, string.rep(" ", indent)) -- indent it
			if type(value) == "table" and not done[value] then
				done[value] = true
				table.insert(sb, key .. " = {\n")
				table.insert(sb, table_print(value, indent + 2, done))
				table.insert(sb, string.rep(" ", indent)) -- indent it
				table.insert(sb, "}\n")
			elseif "number" == type(key) then
				table.insert(sb, string.format('"%s"\n', tostring(value)))
			else
				table.insert(sb, string.format('%s = "%s"\n', tostring(key), tostring(value)))
			end
		end
		return table.concat(sb)
	else
		return tt .. "\n"
	end
end

function to_string(tbl)
	if "nil" == type(tbl) then
		return tostring(nil)
	elseif "table" == type(tbl) then
		return table_print(tbl)
	elseif "string" == type(tbl) then
		return tbl
	else
		return tostring(tbl)
	end
end
