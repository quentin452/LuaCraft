-- Super Simple 3D Engine v1
-- groverburger 2019
Engine.objFormat = {
	{ "VertexPosition", "float", 4 },
	{ "VertexTexCoord", "float", 2 },
	{ "VertexNormal", "float", 3 },
}

-- create a new Model object
-- given a table of verts for example: { {0,0,0}, {0,1,0}, {0,0,1} }
-- each vert is its own table that contains three coordinate numbers, and may contain 2 extra numbers as uv coordinates
-- another example, this with uvs: { {0,0,0, 0,0}, {0,1,0, 1,0}, {0,0,1, 0,1} }
-- polygons are automatically created with three consecutive verts
function Engine.newModel(verts, texture, coords, color, format)
	_JPROFILER.push("Engine.newModel")

	local m = {}

	-- Set default values if no arguments are given
	coords = coords or { 0, 0, 0 }
	color = color or { 1, 1, 1 }
	format = format or {
		{ "VertexPosition", "float", 3 },
		{ "VertexTexCoord", "float", 2 },
	}
	texture = texture or Lovegraphics.newCanvas(1, 1)
	verts = verts or {}

	-- Translate verts by given coords and add random UV coordinates if not given
	local randomUV = #verts > 0 and #verts[1] < 5
	for i = 1, #verts do
		verts[i][1] = verts[i][1] + coords[1]
		verts[i][2] = verts[i][2] + coords[2]
		verts[i][3] = verts[i][3] + coords[3]

		if randomUV then
			verts[i][4] = math.random()
			verts[i][5] = math.random()
		end
	end

	-- Define the Model object's properties
	m.mesh = #verts > 0 and Lovegraphics.newMesh(format, verts, "triangles") or nil
	if m.mesh then
		m.mesh:setTexture(texture)
	end
	m.texture = texture
	m.format = format
	m.verts = verts
	m.transform = TransposeMatrix(Cpml.mat4.identity())
	m.color = color
	m.visible = true
	m.dead = false
	m.wireframe = false
	m.culling = false

	m.setVerts = function(self, newVerts)
		if #newVerts > 0 then
			self.mesh = Lovegraphics.newMesh(self.format, newVerts, "triangles")
			self.mesh:setTexture(self.texture)
		end
		self.verts = newVerts
	end

	-- Translate and rotate the Model
	m.setTransform = function(self, newCoords, rotations)
		rotations = rotations or {}
		self.transform = TransposeMatrix(Cpml.mat4.identity())
		self.transform:translate(self.transform, Cpml.vec3(unpack(newCoords)))
		for i = 1, #rotations, 2 do
			self.transform:rotate(self.transform, rotations[i], rotations[i + 1])
		end
		self.transform = TransposeMatrix(self.transform)
	end

	-- Returns a list of the verts this Model contains
	m.getVerts = function(self)
		local ret = {}
		for i = 1, #self.verts do
			ret[#ret + 1] = { self.verts[i][1], self.verts[i][2], self.verts[i][3] }
		end
		return ret
	end

	-- Prints a list of the verts this Model contains
	m.printVerts = function(self)
		local verts = self:getVerts()
		for i = 1, #verts do
			print(verts[i][1], verts[i][2], verts[i][3])
			if i % 3 == 0 then
				print("---")
			end
		end
	end

	-- Set a texture to this Model
	m.setTexture = function(self, tex)
		if self.mesh then
			self.mesh:setTexture(tex)
		end
	end

	-- Check if this Model must be destroyed (called by the parent Scene model's update function automatically)
	m.deathQuery = function(self)
		return not self.dead
	end

	_JPROFILER.pop("Engine.newModel")
	return m
end

-- create a new Scene object with given canvas output size
function Engine.newScene(renderWidth, renderHeight)
	_JPROFILER.push("Engine.newScene")

	Lovegraphics.setDepthMode("lequal", true)
	scene = {}

	-- define the shaders used in rendering the scene
	scene.threeShader = Lovegraphics.newShader([[
#ifndef PIXEL
uniform mat4 view;
uniform mat4 model_matrix;
mat4 modelView = view * model_matrix;
vec4 position(mat4 transform_projection, vec4 vertex_position) {
return modelView * vertex_position;}
#endif
#ifdef PIXEL
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
vec4 texturecolor = Texel(texture, texture_coords);
if (texturecolor.a < 0.01) discard;
return color * texturecolor;}
#endif
]])
	scene.renderWidth = renderWidth
	scene.renderHeight = renderHeight

	-- create a canvas that will store the rendered 3d scene
	scene.threeCanvas = Lovegraphics.newCanvas(renderWidth, renderHeight)
	-- create a canvas that will store a 2d layer that can be drawn on top of the 3d scene
	scene.twoCanvas = Lovegraphics.newCanvas(renderWidth, renderHeight)
	scene.modelList = {}

	scene.camera = {
		pos = Cpml.vec3(0, 0, 0),
		angle = Cpml.vec3(0, 0, 0),
		perspective = TransposeMatrix(Cpml.mat4.from_perspective(60, renderWidth / renderHeight, 0.1, 10000)),
		transform = Cpml.mat4(),
	}

	-- should be called in love.update every frame
	scene.update = function(self)
		for i = #self.modelList, 1, -1 do
			local thing = self.modelList[i]
			if not thing:deathQuery() then
				table.remove(self.modelList, i)
			end
		end
	end

	-- renders the models in the scene to the threeCanvas
	-- will draw threeCanvas if drawArg is not given or is true (use if you want to scale the game canvas to window)
	scene.render = function(self, drawArg)
		local windowWidth, windowHeight = Lovegraphics.getDimensions()
		local scaleX, scaleY = windowWidth / self.renderWidth, windowHeight / self.renderHeight

		Lovegraphics.setColor(1, 1, 1)
		Lovegraphics.setCanvas({ self.threeCanvas, depth = true })
		Lovegraphics.clear(0, 0, 0, 0)
		Lovegraphics.setShader(self.threeShader)

		local Camera = self.camera
		Camera.transform = Cpml.mat4()
		local t, a, p = Camera.transform, Camera.angle, CopyTable(Camera.pos)
		t:rotate(t, a.y, Cpml.vec3.unit_x)
		t:rotate(t, a.x, Cpml.vec3.unit_y)
		t:rotate(t, a.z, Cpml.vec3.unit_z)
		t:translate(t, Cpml.vec3(-p.x, -p.y, -p.z))
		self.threeShader:send("view", Camera.perspective * TransposeMatrix(t))

		for i = 1, #self.modelList do
			local model = self.modelList[i]
			if model and model.visible and #model.verts > 0 then
				self.threeShader:send("model_matrix", model.transform)
				Lovegraphics.setWireframe(model.wireframe)
				if model.culling then
					Lovegraphics.setMeshCullMode("back")
				end
				Lovegraphics.draw(model.mesh, -self.renderWidth / 2, -self.renderHeight / 2)
				Lovegraphics.setMeshCullMode("none")
				Lovegraphics.setWireframe(false)
			end
		end

		Lovegraphics.setShader()
		Lovegraphics.setCanvas()

		Lovegraphics.setColor(1, 1, 1)
		if drawArg == nil or drawArg then
			Lovegraphics.draw(
				self.threeCanvas,
				windowWidth / 2,
				windowHeight / 2,
				0,
				scaleX,
				-scaleY,
				self.renderWidth / 2,
				self.renderHeight / 2
			)
		end
	end

	-- renders the given func to the twoCanvas
	-- this is useful for drawing 2d HUDS and information on the screen in front of the 3d scene
	-- will draw threeCanvas if drawArg is not given or is true (use if you want to scale the game canvas to window)
	scene.renderFunction = function(self, func, drawArg)
		Lovegraphics.setColor(1, 1, 1)
		Lovegraphics.setCanvas(Scene.twoCanvas)
		Lovegraphics.clear(0, 0, 0, 0)
		func()
		Lovegraphics.setCanvas()

		if drawArg == nil or drawArg == true then
			Lovegraphics.draw(
				Scene.twoCanvas,
				self.renderWidth / 2,
				self.renderHeight / 2,
				0,
				1,
				1,
				self.renderWidth / 2,
				self.renderHeight / 2
			)
		end
	end

	-- useful if mouse relativeMode is enabled
	-- useful to call from love.mousemoved
	-- a simple first person mouse look function
	scene.mouseLook = function(self, x, y, dx, dy)
		local Camera = self.camera
		Camera.angle.x = Camera.angle.x + math.rad(dx * 0.5)
		Camera.angle.y = math.max(math.min(Camera.angle.y + math.rad(dy * 0.5), math.pi / 2), -1 * math.pi / 2)
	end
	_JPROFILER.pop("Engine.newScene")

	return scene
end

-- useful functions
function TransposeMatrix(mat)
	return Cpml.mat4.transpose(Cpml.mat4(), mat)
end

function InvertMatrix(mat)
	return Cpml.mat4.invert(Cpml.mat4(), mat)
end

function CopyTable(orig)
	_JPROFILER.push("CopyTable")
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		copy = {}
		for orig_key, orig_value in pairs(orig) do
			copy[orig_key] = CopyTable(orig_value)
		end
		setmetatable(copy, CopyTable(getmetatable(orig)))
	else
		copy = orig
	end
	_JPROFILER.pop("CopyTable")
	return copy
end
function GetSign(n)
	return n > 0 and 1 or n < 0 and -1 or 0
end

function CrossProduct(v1, v2)
	_JPROFILER.push("CrossProduct")

	local a = { x = v1[1], y = v1[2], z = v1[3] }
	local b = { x = v2[1], y = v2[2], z = v2[3] }

	local x, y, z
	x = a.y * (b.z or 0) - (a.z or 0) * b.y
	y = (a.z or 0) * b.x - a.x * (b.z or 0)
	z = a.x * b.y - a.y * b.x
	_JPROFILER.pop("CrossProduct")

	return { x, y, z }
end
function UnitVectorOf(vector)
	_JPROFILER.push("UnitVectorOf")

	local ab1 = math.abs(vector[1])
	local ab2 = math.abs(vector[2])
	local ab3 = math.abs(vector[3])
	local max = VectorLength(ab1, ab2, ab3)
	if max == 0 then
		max = 1
	end

	local ret = { vector[1] / max, vector[2] / max, vector[3] / max }
	_JPROFILER.pop("UnitVectorOf")

	return ret
end
function VectorLength(x2, y2, z2)
	_JPROFILER.push("VectorLength")

	local x1, y1, z1 = 0, 0, 0
	_JPROFILER.pop("VectorLength")

	return ((x2 - x1) ^ 2 + (y2 - y1) ^ 2 + (z2 - z1) ^ 2) ^ 0.5
end
function TransformVerts(verts, sx, sy, sz, operation)
	_JPROFILER.push(operation .. "Verts")
	if sy == nil then
		sy = sx
		sz = sx
	end
	for i = 1, #verts do
		local this = verts[i]
		if operation == "Scale" then
			this[1] = this[1] * sx
			this[2] = this[2] * sy
			this[3] = this[3] * sz
		elseif operation == "Move" then
			this[1] = this[1] + sx
			this[2] = this[2] + sy
			this[3] = this[3] + sz
		end
	end
	_JPROFILER.pop(operation .. "Verts")
	return verts
end

return Engine
