shader_type canvas_item;
render_mode blend_mul;

uniform float transparency : hint_range(0.0, 1.0, 0.1) = 0;
uniform bool optional_grad ;
uniform sampler2D gradient ;

uniform int blend_mode: hint_enum("ADD", "SUB", "MIX", "MUL");

void handle_color_blend_mode(vec4 _color, vec4 _pass) 
	{
		switch (blend_mode)
		{
			case 1: break;
			case 2: break;
			case 3: break;
			case 4: break;
		}
	}

void fragment()
	{
	if (!optional_grad)
	{
		{ COLOR.a = COLOR.a - transparency; }
	}
	else
	{
		{ COLOR = texture(gradient, UV);}
		
	}
	

	}