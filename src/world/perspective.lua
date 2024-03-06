--By xXxMoNkEyMaNxXx
--[[Complete API----  This was made to be a module, PLEASE USE IT AS A MODULE

   .cw=false
   -Counter clockwise vertex order starting at top left.

   .cw=true
   -Clockwise vertex order starting at top left.


   .preload(loadup):

   -loadup==true sets pixel effect to polygon texturer,
   -loadup==false clears any pixel effect.
   *NOTE: preload(false) must be done to draw blank polygons after textured ones.


   .setRepeat(origin,size):
   -Makes the image repeat every 'size' starting at 'origin'.
   -The default is origin={0,0},size={1,1}.


   .quad(image,v1,v2,v3,v4) - Draws a polygon.

   -if 'image' is nil, the function will prepare to make it blank.


   .quad(v1,v2,v3,v4) - draws a polygon with no image.


   .fast(image,v1,v2,v3,v4) - draws a polygon with 'image' on it.
   -slightly(!!!) faster than quad.
   -Must include an image.
   -Must call .preload(true) beforehand.


   Info:
   Vertices are in the form {x,y}.
   Vertices go clockwise from the top left.

   v1---v2
   | img |
   v4---v3
--]]
local glsl = love.graphics.newShader([[
//Made by xXxMoNkEyMaNxXx

extern Image img;
extern vec2 v1;
extern vec2 v2;
extern vec2 v3;
extern vec2 v4;

extern vec2 p0;
extern vec2 rep;

vec2 one = vec2(1.0, 1.0);

number c(vec2 v1, vec2 v2)
{
   return v1.x * v2.y - v2.x * v1.y;
}

number intersect(vec2 v1, vec2 d1, vec2 v2, vec2 d2)
{
   return c(v2 - v1, d2) / c(d1, d2);
}

vec4 mask(vec4 base, vec4 over)
{
   return base * over;
}

vec4 effect(vec4 colour, Image UNUSED1, vec2 UNUSED2, vec2 inverted)
{
   vec2 p = vec2(inverted.x, inverted.y);

   vec2 A1 = normalize(v2 - v1);
   vec2 A2 = normalize(v3 - v4);

   vec2 B1 = normalize(v2 - v3);
   vec2 B2 = normalize(v1 - v4);

   number Adiv = c(A1, A2);
   number Bdiv = c(B1, B2);

   vec2 uv;

   bvec2 eq0 = bvec2(abs(Adiv) <= 0.0001, abs(Bdiv) <= 0.0001);

   if (all(eq0))
   {
      // Both edges are parallel, therefore the shape is a parallelogram (Isometric)
      number dis = dot(p - v1, A1);
      number ct = dot(A1, B1);
      vec2 pA = v1 + A1 * dis;
      number r = length(p - pA) / sqrt(1.0 - ct * ct);
      uv = vec2(1.0 - r / length(v2 - v3), (dis + r * ct) / length(v2 - v1));
   }
   else
   {
      vec2 Vp;
      vec2 D;
      number u;
      number v;
      number len;

      if (eq0.x)
      {
         Vp = v3 + B1 * c(v4 - v3, B2) / Bdiv;
         D = Vp + A1 * intersect(Vp, A1, v4, normalize(v2 - v4));
         u = intersect(v1, A1, Vp, normalize(p - Vp));
         v = intersect(v1, A1, D, normalize(p - D)) - u;
         len = length(v2 - v1);
         uv = vec2(len - v, u) / len;
      }
      else if (eq0.y)
      {
         Vp = v1 + A1 * c(v4 - v1, A2) / Adiv;
         D = Vp + B1 * intersect(Vp, B1, v4, normalize(v2 - v4));
         u = intersect(v3, B1, Vp, normalize(p - Vp));
         len = length(v2 - v3);
         uv = vec2(u, len - intersect(v3, B1, D, normalize(p - D)) + u) / len;
      }
      else
      {
         vec2 A = v1 + A1 * c(v4 - v1, A2) / Adiv;
         vec2 B = v3 + B1 * c(v4 - v3, B2) / Bdiv;
         vec2 H = normalize(A - B);
         uv = vec2(intersect(v4, -H, A, normalize(p - A)) / intersect(v4, -H, v2, -A1),
                   intersect(v4, H, B, normalize(p - B)) / intersect(v4, H, v2, -B1));
      }
   }

   return mask(colour, Texel(img, mod(uv * rep + vec2(p0.x - 1, p0.y), one)));
}
]])
local pers = {}
local gl_send = glsl.send
local love_graphics = love.graphics
local polygon = love_graphics.polygon
local setEffect = love_graphics.setShader

gl_send(glsl, "p0", { 1, 1 })
gl_send(glsl, "rep", { 1, 1 })

pers.cw = true -- Clockwise
pers.flip = false -- Flip the image

function pers.preload(loadup)
	_JPROFILER.push("pers.preload")
	if loadup then
		setEffect(glsl)
	else
		setEffect()
	end
	_JPROFILER.pop("pers.preload")
end

function pers.setRepeat(origin, size)
	_JPROFILER.push("setRepeat")

	gl_send(glsl, "p0", origin)
	gl_send(glsl, "rep", size)
	_JPROFILER.pop("setRepeat")
end

function pers.fast(img, v1, v2, v3, v4)
	_JPROFILER.push("pers.fast")

	gl_send(glsl, "img", img)
	gl_send(glsl, "v1", v2)
	gl_send(glsl, "v2", v3)
	gl_send(glsl, "v3", v4)
	gl_send(glsl, "v4", v1)
	polygon("fill", v1[1], v1[2], v2[1], v2[2], v3[1], v3[2], v4[1], v4[2])
	_JPROFILER.pop("pers.fast")
end

function pers.quad(img, v1, v2, v3, v4, h)
	_JPROFILER.push("pers.quad")

	if h then
		sendHeightToShader(h)
	end

	if img and v4 then
		setupEffect(glsl)
		sendVerticesToShader(img, v1, v2, v3, v4)
		renderPolygon(v1, v2, v3, v4, img)
		resetEffect()
	end

	_JPROFILER.pop("pers.quad")
end

function sendHeightToShader(h)
	_JPROFILER.push("sendHeightToShader")
	gl_send(glsl, "SIZEY", h)
	_JPROFILER.pop("sendHeightToShader")
end

function setupEffect(glsl)
	_JPROFILER.push("setupEffect")
	setEffect(glsl)
	_JPROFILER.pop("setupEffect")
end

function sendVerticesToShader(img, v1, v2, v3, v4)
	_JPROFILER.push("sendVerticesToShader")

	local v1_, v2_, v3_, v4_

	if pers.cw then
		if not pers.flip then
			v1_, v2_, v3_, v4_ = v2, v3, v4, v1
		else
			v1_, v2_, v3_, v4_ = v1, v4, v3, v2
		end
	else
		v1_, v2_, v3_, v4_ = v2, v1, v4, v3
	end

	gl_send(glsl, "img", img)
	gl_send(glsl, "v1", v1_)
	gl_send(glsl, "v2", v2_)
	gl_send(glsl, "v3", v3_)
	gl_send(glsl, "v4", v4_)

	_JPROFILER.pop("sendVerticesToShader")
end

function resetEffect()
	_JPROFILER.push("resetEffect")
	setEffect()
	_JPROFILER.pop("resetEffect")
end

function renderPolygon(v1, v2, v3, v4, img)
	_JPROFILER.push("renderPolygon")
	if v4 then
		polygon("fill", v1[1], v1[2], v2[1], v2[2], v3[1], v3[2], v4[1], v4[2])
	else
		polygon("fill", img[1], img[2], v1[1], v1[2], v2[1], v2[2], v3[1], v3[2])
	end
	_JPROFILER.pop("renderPolygon")
end

return pers
