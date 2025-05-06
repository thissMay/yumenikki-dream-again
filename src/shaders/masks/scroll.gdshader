shader_type canvas_item;

global uniform vec2 uv_offset;

uniform sampler2D world_texture : source_color, repeat_enable;
uniform float dirX;
uniform float dirY;

void vertex()
{
	UV = (MODEL_MATRIX * vec4(UV, TEXTURE_PIXEL_SIZE)).xy + (uv_offset);
}

void fragment() {
	float mask = texture(TEXTURE, SCREEN_UV).a;
	vec2 scroll_dir = -vec2(dirX / 10., dirY / 10.) * (TIME);
	vec4 panorama = texture(world_texture, SCREEN_UV + scroll_dir);

	COLOR.a *= mask;

	COLOR.x = panorama.x;
	COLOR.y = panorama.y;
	COLOR.z = panorama.z;
}