shader_type canvas_item;

uniform vec4 colour: source_color = vec4(0,0,0,1);
uniform float transparency: hint_range(0.0, 1.0, 0.1) = 1;
uniform float progress: hint_range(0.0, 1.0, 0.1) = 0;

void fragment()
{
	COLOR.rgb = colour.rgb;
	COLOR.a = (transparency * progress);
}