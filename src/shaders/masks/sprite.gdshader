shader_type canvas_item;

#include "res://src/shaders/panorama/linear_base.gdshaderinc"
#include "res://src/shaders/panorama/general_base.gdshaderinc"


uniform sampler2D world_texture : source_color, repeat_enable;


void vertex()
{
}

void fragment() {
	float mask = texture(TEXTURE, UV).a;
	COLOR = _linear_fragment(SCREEN_UV, world_texture) + texture(TEXTURE, UV) * overlay_modulate;
	COLOR.a *= mask - transparency;
}