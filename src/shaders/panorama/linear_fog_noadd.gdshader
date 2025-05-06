shader_type canvas_item;
render_mode world_vertex_coords;

uniform float transparency : hint_range(0, 1.0, 0.1) = 0;
uniform float dirX : hint_range(-1.0, 1.0, 0.1);
uniform float dirY : hint_range(-1.0, 1.0, 0.1);
uniform float scroll_speed : hint_range(0.0, .75, 0.01);

uniform sampler2D noise : repeat_enable;

global uniform vec2 uv_offset;
uniform float offset_strength;
uniform float offset_strength_x_influence = 1;
uniform float offset_strength_y_influence = 1;

void vertex()
{
	UV.x = ((MODEL_MATRIX * vec4(UV, TEXTURE_PIXEL_SIZE)).xy + ((uv_offset / 2.5) * (offset_strength * offset_strength_x_influence))).x;
	UV.y = ((MODEL_MATRIX * vec4(UV, TEXTURE_PIXEL_SIZE)).xy + (uv_offset * (offset_strength * offset_strength_y_influence))).y;
}

void fragment()
{
	vec2 uv = UV;
	vec2 scroll_dir = -vec2(dirX, dirY) * (TIME * scroll_speed);
	vec4 noise_panorama = texture(noise, UV + scroll_dir);
	vec4 wave_texture = texture(TEXTURE, UV + scroll_dir / 3.);

	COLOR = vec4
		(
			wave_texture.r * noise_panorama.r ,
			wave_texture.g * noise_panorama.g ,
			wave_texture.b * noise_panorama.b ,
			wave_texture.a - transparency
		);
}