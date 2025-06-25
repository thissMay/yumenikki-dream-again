shader_type canvas_item;
render_mode blend_mul;

#include "res://src/shaders/panorama/general_base.gdshaderinc"

uniform bool optional_grad ;
uniform sampler2D gradient ;

void fragment()
	{
		if (optional_grad) 	{ COLOR.rgb = texture(gradient, UV).rgb;}
		else			 	{ COLOR.rgb = texture(TEXTURE, UV).rgb;}

		COLOR.a = 1. - transparency;
	}