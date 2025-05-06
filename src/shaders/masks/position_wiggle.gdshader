shader_type canvas_item;

uniform float x_scale_amplitude = 1;
uniform float x_scale_speed = 1;

uniform float y_scale_amplitude = 1;
uniform float y_scale_speed = 1;


void vertex()
{
	// sin^2(x) + c
	VERTEX.x =  VERTEX.x + 12.* sin(TIME);
	VERTEX.y = VERTEX.y + 12.* cos(TIME);
}
