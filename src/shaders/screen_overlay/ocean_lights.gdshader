
shader_type canvas_item;
render_mode blend_add;

#include "res://src/shaders/panorama/depth_base.gdshaderinc"

uniform float opacity : hint_range(0.0, 1.0, 0.1) = 1;
uniform sampler2D noise : repeat_enable;

uniform float scroll_speed : hint_range(-0.085, 0.085, 0.01 ) = 0.05;

uniform sampler2D gradient;

uniform float ray_strength = 1.225;

void vertex()
{
	UV = _depth_vertex(UV, TEXTURE_PIXEL_SIZE);
}

void fragment()
{


	vec4 noise_scroll_fwd = texture(noise, UV.x + vec2(TIME * scroll_speed));
	vec4 noise_scroll_back = texture(noise, UV.x - vec2(TIME * scroll_speed / 5.0));

	COLOR.rgb = (noise_scroll_fwd * noise_scroll_back).rgb * texture(gradient, UV).rgb * ray_strength;
	COLOR.a = opacity / (ray_strength / 3.);


}
