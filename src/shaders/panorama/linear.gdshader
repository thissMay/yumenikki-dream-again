shader_type canvas_item;
#include "res://src/shaders/panorama/linear_base.gdshaderinc"



void vertex()
{
	UV = _depth_vertex(UV, TEXTURE_PIXEL_SIZE);
}

void fragment()
{
	COLOR = _linear_fragment(UV, TEXTURE);
}

