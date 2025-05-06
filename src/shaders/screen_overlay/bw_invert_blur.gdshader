shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float blur_amount : hint_range(0, 5) = 1.5; // Strength of the blur effect
uniform float pixel_size = 400; // Strength of the blur effect
uniform float contrast = 1;

vec4 blur_size(sampler2D tex,vec2 fragCoord, vec2 pixelSize) {

    vec4 color =  - vec4(0.,0.,0.,0.);
    float strengthFloat = float(blur_amount);

    vec2 pixel = fragCoord/pixelSize;
    int x_min = max(int(pixel.x-strengthFloat), 0);
    int x_max = min(int(pixel.x+strengthFloat), int(1./pixelSize.x));
    int y_min = max(int(pixel.y-strengthFloat), 0);
    int y_max = min(int(pixel.y+strengthFloat), int(1./pixelSize.y));

    int count = 0;

    // Sum the pixels colors
    for(int x=x_min; x <= x_max; x++) {
        for(int y = y_min; y <= y_max; y++) {
            color += texture(tex, vec2(float(x), float(y)) * pixelSize);
            count++;
        }
    }

    // Divide the color by the number of colors you summed up
    color /= float(count);

    return color;
}

void fragment() {

	vec3 invert_color = vec3(1.) - blur_size(SCREEN_TEXTURE, SCREEN_UV, vec2(1./pixel_size)).rgb * contrast;
    vec3 grayscale =
		mix(
			vec3(
				(invert_color.r +
				invert_color.g +
				invert_color.b) / 2.25),
				vec3(
					0.01 *
					vec3(1.) - blur_size(SCREEN_TEXTURE, SCREEN_UV, vec2(1./pixel_size)).r + 0.375 *
					vec3(1.) - blur_size(SCREEN_TEXTURE, SCREEN_UV, vec2(1./pixel_size)).g + 0.375 *
					vec3(1.) - blur_size(SCREEN_TEXTURE, SCREEN_UV, vec2(1./pixel_size)).b)
					,float(.1));

	COLOR.rgb = grayscale - vec3(.5);
}

// credits: https://godotshaders.com/shader/configurable-box-blur/
