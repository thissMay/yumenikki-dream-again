shader_type canvas_item;

uniform float alpha : hint_range(0.0, 1.0, 0.01) = 0.5;
uniform float noise_amount : hint_range(0.0, 1.0, 0.01) = 0.05;

uniform bool inverted = false;

void noise(in vec2 uv, inout vec4 color) {
	float a =  mix(fract(sin(dot(uv, vec2(12.9898, 78.233) * TIME)) * 250.5453) * 1.2, .5, 10);
	color.rgb = mix(color.rgb, vec3(a), noise_amount * float(inverted ? -1 : 1));
}


vec4 color_shift(in vec2 uv, in sampler2D image, vec2 shift_vector) {
	return texture(image, uv - shift_vector);
}

void fragment() {	// change the "240.0" literal to control line color shifting
	noise(UV, COLOR);
	COLOR.a = alpha * COLOR.a;
}