shader_type canvas_item;
render_mode blend_mul;

uniform float transparency : hint_range(0.0, 1.0, 0.1) = 0;
uniform bool optional_grad ;
uniform sampler2D gradient ;

void fragment()
	{
		if (optional_grad) 	{ COLOR.rgb = texture(gradient, UV).rgb;}
		else			 	{ COLOR.rgb = texture(TEXTURE, UV).rgb;}

		COLOR.a = 1. - transparency;
	}