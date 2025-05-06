shader_type canvas_item;
render_mode world_vertex_coords;

global uniform vec2 uv_offset;
uniform float offset_strength;
uniform float offset_strength_x_influence = 1;
uniform float offset_strength_y_influence = 1;

void vertex()
{
	UV.x = ((vec4(UV, TEXTURE_PIXEL_SIZE)).xy + ((uv_offset / 2.5) * (offset_strength * offset_strength_x_influence))).x;
	UV.y = ((vec4(UV, TEXTURE_PIXEL_SIZE)).xy + (uv_offset * (offset_strength * offset_strength_y_influence))).y;
}