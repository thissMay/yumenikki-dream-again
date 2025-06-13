shader_type canvas_item;
render_mode blend_mul;

uniform float transparency : hint_range(0.0, 1.0, 0.1) = 0;
uniform bool optional_grad ;
uniform sampler2D gradient ;

void fragment()
	{
		if (optional_grad)
		{ COLOR = texture(gradient, UV);}
		else			
		{ COLOR = texture(TEXTURE, UV);}
	}