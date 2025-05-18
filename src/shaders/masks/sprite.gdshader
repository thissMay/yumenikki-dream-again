shader_type canvas_item;

#include "res://src/shaders/panorama/linear_base.gdshaderinc"

uniform sampler2D world_texture : source_color, repeat_enable;


void vertex()
{

}

void fragment() {
	float mask = texture(TEXTURE, UV).a;

	COLOR.rgb = _fragment(SCREEN_UV, world_texture).rgb;
	COLOR.a *= mask;
}