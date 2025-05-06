shader_type canvas_item;


uniform sampler2D world_texture : source_color, repeat_enable;
global uniform vec2 uv_offset;

void vertex()
{

}

void fragment() {
	float mask = texture(TEXTURE, UV).a;
	COLOR.rgb = texture(world_texture, UV).rgb;
	COLOR.a *= mask;
}