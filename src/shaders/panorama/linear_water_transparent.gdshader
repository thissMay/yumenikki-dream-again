shader_type canvas_item;
render_mode world_vertex_coords;

// ---- general.
uniform float transparency : hint_range(0, 1.0, 0.1) = 0;
uniform float dirX : hint_range(-1.0, 1.0, 0.1);
uniform float dirY : hint_range(-1.0, 1.0, 0.1);
uniform float scroll_speed : hint_range(0.0, .75, 0.01);

// ---- fog.
uniform sampler2D noise : repeat_enable;
uniform vec3 color_overlay: source_color = vec3(1);
uniform float color_overlay_intensity = 1;

// ---- distortion waves.
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
uniform float noise_strength : hint_range(-0.085, 1, 0.01 ) = 0.025;
uniform sampler2D noise_distort : repeat_enable;
uniform float noise_speed = 1;

// ---- general.
uniform vec2 uv_offset = vec2(0);
uniform float offset_strength = 1;

void vertex()
{
	UV = (MODEL_MATRIX * vec4(UV, TEXTURE_PIXEL_SIZE)).xy + (uv_offset * offset_strength);
}

void fragment()
{
	vec2 uv = UV;
	vec2 scroll_dir = -vec2(dirX, dirY) * (TIME * scroll_speed);
	vec4 noise_panorama = (texture(noise, UV + scroll_dir / 1.07) * 6.2);
	vec4 wave_texture = (texture(TEXTURE, UV + scroll_dir / 2.1) * 1.7);

	vec4 distort_scroll = texture(noise_distort, uv + vec2(TIME * (noise_speed / 10.)));
	vec4 distort_effect = texture(
		SCREEN_TEXTURE,
		SCREEN_UV + scroll_speed * (noise_strength * distort_scroll.xy) * noise_strength);


	COLOR = vec4
		(
			(distort_effect.r) + color_overlay_intensity * (wave_texture.r / noise_panorama.r) * color_overlay.r,
			(distort_effect.g) + color_overlay_intensity * (wave_texture.g / noise_panorama.g) * color_overlay.g ,
			(distort_effect.b) + color_overlay_intensity * (wave_texture.b / noise_panorama.b) * color_overlay.b ,
			1. - transparency
		);
}