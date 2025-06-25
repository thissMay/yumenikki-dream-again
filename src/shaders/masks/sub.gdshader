shader_type canvas_item;
render_mode blend_sub;

#include "res://src/shaders/panorama/general_base.gdshaderinc"

void fragment()
{ COLOR.a = COLOR.a - transparency; }
