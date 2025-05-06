shader_type canvas_item;
#include "res://src/shaders/panorama/linear_base.gdshaderinc"

void vertex()
{
	_vertex(UV, TEXTURE_PIXEL_SIZE, MODEL_MATRIX);
}

void fragment()
{
	_fragment(UV, TEXTURE, COLOR);
}

