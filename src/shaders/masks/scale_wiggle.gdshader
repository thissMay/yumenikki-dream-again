shader_type canvas_item;

uniform float x_scale_amplitude = 1;
uniform float x_scale_speed = 1;

uniform float y_scale_amplitude = 1;
uniform float y_scale_speed = 1;


void vertex()
{
	// sin^2(x) + c

	VERTEX.x +=  (1. / 15. * x_scale_amplitude) * (pow(sin(x_scale_speed * TIME), 2)) * VERTEX.x;
	VERTEX.y +=  (1. / 15. * y_scale_amplitude) * (pow(cos(y_scale_speed * (TIME / 1.85)), 2)) * VERTEX.y;

}
