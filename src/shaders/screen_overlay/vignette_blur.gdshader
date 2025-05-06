shader_type canvas_item;

uniform sampler2D screen_texture:
		hint_screen_texture,
		repeat_disable,
		filter_linear_mipmap;
uniform float blur_radius : hint_range(0, 1) = 0.2; // Radius of the blur effect
uniform float blur_amount : hint_range(0, 5) = 1.0; // Strength of the blur effect
uniform float blur_inner : hint_range(0, 1) = 0.6; // Inner edge of the blur effect
uniform float blur_outer : hint_range(0, 1) = 0.66; // Outer edge of the blur effect

void fragment() {
    // Original color of the pixel from the screen
    vec4 pixelColor = texture(screen_texture, SCREEN_UV);

    // Color with blur effect from the screen
    vec4 blurColor = textureLod(screen_texture, SCREEN_UV, blur_amount) -.05;

    // Calculate distance from the center of the screen
    float distance = length(UV - vec2(0.5, 0.5));

    // Apply smoothstep function to control transition between areas
    float blur = smoothstep(blur_inner - blur_radius, blur_outer, distance);

    blurColor.a = blur;


    // Mix colors of the blur effect with white for an additional effect
    //blurColor.rgb = mix(blurColor.rgb, vec3(.3), .0);

    // Set the final color to the modified color of the blur effect
    COLOR = blurColor;
}

// credits: https://godotshaders.com/shader/blur-vignette-post-processing-colorrect-godot-4-2-1/