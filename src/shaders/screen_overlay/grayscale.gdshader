shader_type canvas_item;
uniform sampler2D screen_texture : hint_screen_texture;
uniform float r_intensity = 0.375;
uniform float g_intensity = 0.375;
uniform float b_intensity = 0.375;

void fragment() {
	COLOR = texture(screen_texture, SCREEN_UV);
    COLOR.rgb = 
		mix(
			vec3((COLOR.r + COLOR.g + COLOR.b) / 3.0),  
			vec3(r_intensity * COLOR.r + g_intensity * COLOR.g + b_intensity * COLOR.b)
			, float(1));
	COLOR.a = 0.25;
}
