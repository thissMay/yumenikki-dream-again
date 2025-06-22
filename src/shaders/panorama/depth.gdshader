shader_type canvas_item;
render_mode world_vertex_coords;

#include "depth_base.gdshaderinc"

void vertex() {UV = _depth_vertex(UV, TEXTURE_PIXEL_SIZE);}