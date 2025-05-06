shader_type canvas_item;

uniform vec4 first_color : source_color= vec4(0.0, 0.0, 0.0, 1);
uniform vec4 second_color : source_color = vec4(0.0);
uniform float position : hint_range(-0.5, 0.5) = 0;
uniform float size : hint_range(0.5, 2) = 1;
uniform float angle : hint_range(0.0, 360.0) = 0.0;

void fragment() {
	float pivot = position + 0.5;
	vec2 uv = UV - pivot;
	float rotated = uv.x * cos(radians(angle)) - uv.y * sin(radians(angle)); 
	float pos = smoothstep((1.0 - size) + position, size + 0.0001 + position, rotated + pivot);
	COLOR.a = texture(TEXTURE, UV).a * mix(first_color, second_color, pos).a; 
}