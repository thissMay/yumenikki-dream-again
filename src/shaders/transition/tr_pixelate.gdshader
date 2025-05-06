shader_type canvas_item;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;
uniform float pixel_size : hint_range(1.0, 16.0, 1.0) = 1.0;
uniform float progress: hint_range(0.0, 1.0, 0.1) = 0;

void fragment()
{
	float x =  FRAGCOORD.x - mod(FRAGCOORD.x, progress * 32.);
	float y =  FRAGCOORD.y - mod(FRAGCOORD.y, progress * 32.);
	float shift = (pixel_size / 2.0);
	COLOR = texture(SCREEN_TEXTURE, vec2(x + shift, y + shift) * SCREEN_PIXEL_SIZE);
} 
