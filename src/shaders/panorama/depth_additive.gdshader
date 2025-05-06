shader_type canvas_item;
render_mode blend_add;

uniform sampler2D world_texture : source_color, repeat_enable;

global uniform vec2 uv_offset;
uniform float offset_strength = 0.235;
uniform float transparency = 0;


void vertex()
{

	UV.x = ((MODEL_MATRIX * vec4(UV, TEXTURE_PIXEL_SIZE)).xy + ((uv_offset / 2.5) * (offset_strength))).x;
	UV.y = ((MODEL_MATRIX * vec4(UV, TEXTURE_PIXEL_SIZE)).xy + (uv_offset * (offset_strength))).y;

}

void fragment()
{
	COLOR.r = COLOR.r;
	COLOR.g = COLOR.g;
	COLOR.b = COLOR.b;
	COLOR.a = 1. - transparency;
}