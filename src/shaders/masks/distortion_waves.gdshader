shader_type canvas_item;

uniform float transparency : hint_range(0, 1.0, 0.1) = 0;
uniform float dirX : hint_range(-1.0, 1.0, 0.1);
uniform float dirY : hint_range(-1.0, 1.0, 0.1);
uniform float scroll_speed : hint_range(-0.085, 0.5, 0.01 ) = 0.25;

uniform float noise_strength : hint_range(-0.085, 1, 0.01 ) = 0.025;
uniform sampler2D noise_fwd : repeat_enable;

uniform vec4 modulate_overlay: source_color;

void fragment()
{

	vec2 uv = UV;
	vec2 scroll_dir = -vec2(dirX, dirY) * (scroll_speed / 2.);

	vec4 noise_scroll_fwd = texture(noise_fwd, uv + vec2(TIME * (scroll_dir)));
	vec4 wave_effect = texture(TEXTURE, uv + scroll_speed * ((vec2(noise_scroll_fwd.x,  noise_scroll_fwd.y)) * noise_strength * (vec2(noise_scroll_fwd.x,  noise_scroll_fwd.y))) * noise_strength);

		COLOR = wave_effect * modulate_overlay;

}
