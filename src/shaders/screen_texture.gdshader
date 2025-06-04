shader_type canvas_item;
render_mode world_vertex_coords;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, repeat_enable;
uniform vec2 offset;
varying vec2 screen_uv;

void fragment() {
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV + (UV * (SCREEN_PIXEL_SIZE / TEXTURE_PIXEL_SIZE)));
}

void vertex()
{
	UV.x = ((MODEL_MATRIX) * vec4(UV, TEXTURE_PIXEL_SIZE)).x + (offset.x);
}
