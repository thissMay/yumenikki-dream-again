#define LOOP_MODE 0
#define LOOP_MODE_ENABLED 0
#define LOOP_MODE_DISABLED 2

global uniform vec2 uv_offset;
uniform int type = 0;
uniform vec2 uv_offset_initial;

uniform float offset_strength;
uniform float offset_strength_x_influence = 1;
uniform float offset_strength_y_influence = 1;
uniform vec2 initial_uv_offset;

vec2 _vertex(vec2 uv, vec2 _pixel_size)
{
	uv.x = ((vec4(uv, _pixel_size)).xy + ((uv_offset / 2.5) * (offset_strength * offset_strength_x_influence))).x + uv_offset_initial.x;
	uv.y = ((vec4(uv, _pixel_size)).xy + (uv_offset * (offset_strength * offset_strength_y_influence))).y + uv_offset_initial.y;
	return uv;
}