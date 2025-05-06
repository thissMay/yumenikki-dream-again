shader_type canvas_item;



uniform float opacity : hint_range(0.0, 1.0, 0.1) = 1;
uniform sampler2D noise : repeat_enable;

uniform float scroll_speed : hint_range(-0.085, 0.085, 0.01 ) = 0.05;
uniform float offset_strength : hint_range(-0.085, 0.085, 0.01 ) = 0.05;
uniform vec2 uv_offset = vec2(0);
uniform bool enabled = false;

uniform float ray_strength = 1.225;

void vertex()
{
	UV.x = ((MODEL_MATRIX * vec4(UV, TEXTURE_PIXEL_SIZE)).xy + (uv_offset * offset_strength)).x;
}

void fragment()
{
	vec4 noise_scroll_fwd = texture(noise, UV.x + vec2(TIME * scroll_speed));
	vec4 noise_scroll_back = texture(noise, UV.x - vec2(TIME * scroll_speed / 5.0));

	COLOR.x = (noise_scroll_fwd * noise_scroll_back).x * texture(TEXTURE, UV).x * ray_strength;
	COLOR.y = (noise_scroll_fwd * noise_scroll_back).x * texture(TEXTURE, UV).y * ray_strength;
	COLOR.z = (noise_scroll_fwd * noise_scroll_back).x * texture(TEXTURE, UV).z * ray_strength;

}
