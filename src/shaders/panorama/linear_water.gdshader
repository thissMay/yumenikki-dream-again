shader_type canvas_item;
render_mode world_vertex_coords;

// ---- general.
uniform float transparency : hint_range(0, 1.0, 0.1) = 0;
uniform float dirX : hint_range(-1.0, 1.0, 0.1);
uniform float dirY : hint_range(-1.0, 1.0, 0.1);
uniform float scroll_speed : hint_range(0.0, .75, 0.01);

// ---- fog.
uniform sampler2D noise : repeat_enable;
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
	vec2 scroll_dir = -vec2(dirX, dirY);
	vec4 distort_scroll = texture(noise_distort, uv + scroll_dir * vec2(TIME * (noise_speed / 10.)));

	vec4 distort_effect_uv = texture(
		TEXTURE,
		UV - (noise_strength * distort_scroll.xy) * noise_strength);
	vec4 distort_effect_screen = texture(
		SCREEN_TEXTURE,
		vec2(SCREEN_UV) + ((noise_strength / 15.) * distort_scroll.xy));

	COLOR.rgb = (mix(distort_effect_screen, COLOR, .4)).rgb;

}