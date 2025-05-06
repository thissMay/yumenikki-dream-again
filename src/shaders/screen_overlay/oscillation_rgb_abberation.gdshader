shader_type canvas_item;

uniform float initial_time = 0;

uniform float r_oscillation_strength = 1;
uniform float r_oscillation_speed = 1;

uniform float b_oscillation_strength = 1;
uniform float b_oscillation_speed = 1;

uniform vec2 abberation_direction = vec2(1,0);

uniform sampler2D screen_texture : hint_screen_texture;

void fragment()
{
	vec2 direction_r = (SCREEN_UV) + (r_oscillation_strength * SCREEN_PIXEL_SIZE) * sin(r_oscillation_speed * TIME + initial_time) * abberation_direction;
	vec2 direction_b = (SCREEN_UV) + (b_oscillation_strength * SCREEN_PIXEL_SIZE) * -sin(b_oscillation_speed * TIME + initial_time) * abberation_direction;

	COLOR.r = texture(screen_texture, vec2(direction_r.x, direction_r.y)).r;
	COLOR.b = texture(screen_texture, vec2(direction_b.x, direction_b.y)).b;
	COLOR.g = texture(screen_texture, (SCREEN_UV)).g;
	COLOR.a = 1.;
}