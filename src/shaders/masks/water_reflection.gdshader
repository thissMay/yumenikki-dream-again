shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D world_texture : repeat_enable;
uniform sampler2D reflection_mask_gradient;

uniform sampler2D screen_texture : hint_screen_texture;
uniform vec2 uv_offset = vec2(0);
uniform float offset_strength = 1;

uniform float opaqueness = 1.25;
uniform float color_intensity = 1.25;

void fragment() {
	float mask = texture(TEXTURE, UV).a;
	vec4 reflected_screenuv = texture(screen_texture, SCREEN_UV);

	vec4 reflection_bg = texture(world_texture, (SCREEN_UV) - (uv_offset) / -(offset_strength * 10.));
	vec4 reflection_grad = texture(reflection_mask_gradient, SCREEN_UV);

	COLOR.rgb = vec4(mix(reflection_grad, reflection_bg, color_intensity)).rgb + reflected_screenuv.rgb;


	reflection_bg.a = reflection_bg.a - 1.;

	COLOR.a = (opaqueness - reflection_bg.a) * mask;
}

// credits: https://godotforums.org/d/37417-tilemaps-as-sprite-masks/2