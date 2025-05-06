shader_type canvas_item;

uniform sampler2D screen_capture : hint_screen_texture;

void fragment()
{
	COLOR = texture(screen_capture, SCREEN_UV);
}