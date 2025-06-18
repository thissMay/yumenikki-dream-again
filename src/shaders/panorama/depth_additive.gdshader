shader_type canvas_item;
render_mode world_vertex_coords, blend_add;

#include "depth_base.gdshaderinc"


void vertex() {UV = _vertex(UV, TEXTURE_PIXEL_SIZE);}