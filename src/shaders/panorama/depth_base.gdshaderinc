
global uniform vec2 uv_offset;
uniform float offset_strength;
uniform float offset_strength_x_influence = 1;
uniform float offset_strength_y_influence = 1;

vec2 _vertex(vec2 uv, vec2 _pixel_size)
{
	uv.x = ((vec4(uv, _pixel_size)).xy + ((uv_offset / 2.5) * (offset_strength * offset_strength_x_influence))).x;
	uv.y = ((vec4(uv, _pixel_size)).xy + (uv_offset * (offset_strength * offset_strength_y_influence))).y;
	return uv;
}