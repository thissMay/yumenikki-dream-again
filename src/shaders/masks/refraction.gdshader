shader_type canvas_item;
render_mode blend_add;

uniform sampler2D world_texture : source_color, repeat_enable;

varying vec4 vec4_offset;
varying vec2 uv_offset;
uniform float offset_strength = 1;
uniform float transparency : hint_range(0.0, 1.0, 0.1);

void vertex() {
	UV = (MODEL_MATRIX * vec4(UV, TEXTURE_PIXEL_SIZE)).xy + (uv_offset * offset_strength);
}

void fragment() {
	vec4 mask = texture(TEXTURE, UV);
	float mask_a = mask.a;
	vec4 color = texture(world_texture, (SCREEN_UV + uv_offset));

	COLOR.rgb = color.rgb;
	COLOR.a = (color.a * mask_a) - transparency;
}