shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;
uniform vec2 offset;

void fragment() {
	COLOR = texture(SCREEN_TEXTURE, SCREEN_UV);
}

void vertex() {
	UV += offset;
}

