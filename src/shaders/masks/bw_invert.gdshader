shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform bool invert = true;
uniform float contrast = 1;


void fragment() {
	vec3 invert_color;

	if (invert) invert_color = contrast * (vec3(1.) - COLOR.rgb);
	else invert_color = contrast * (COLOR.rgb);

    vec3 grayscale =
		mix(
			vec3(
				(invert_color.r +
				invert_color.g +
				invert_color.b) / 3.05),
				vec3(
					0.01 *
					vec3(1.) - COLOR.r + 0.375 *
					vec3(1.) - COLOR.b *
					vec3(1.) - COLOR.g)
					,float(.0));

	COLOR.rgb = grayscale;
}
