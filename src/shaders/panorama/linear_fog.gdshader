shader_type canvas_item;
render_mode world_vertex_coords, blend_add;

#include "res://src/shaders/panorama/linear_base.gdshaderinc"

uniform sampler2D noise : repeat_enable;
uniform vec3 color_overlay: source_color = vec3(1);
uniform float color_overlay_intensity = 1;

void fragment()
{
	vec2 scroll_dir = -vec2(dirX, dirY) * (TIME * scroll_speed);
	vec4 noise_panorama = (texture(noise, UV + scroll_dir / 1.07) * 6.2);
	vec4 wave_texture = (texture(TEXTURE, UV + scroll_dir / 2.1) * 1.1);

	COLOR = vec4
		(
			color_overlay_intensity * (wave_texture.r / noise_panorama.r) * color_overlay.r,
			color_overlay_intensity * (wave_texture.g / noise_panorama.g) * color_overlay.g,
			color_overlay_intensity * (wave_texture.b / noise_panorama.b) * color_overlay.b,
			COLOR.a- transparency
		);
}

void vertex()
	{
		_vertex(UV, TEXTURE_PIXEL_SIZE, MODEL_MATRIX);
	}