shader_type canvas_item;
render_mode blend_add;

#include "general_base.gdshaderinc"
#include "depth_base.gdshaderinc"
#include "radial_base.gdshaderinc"

uniform bool rotation = true;

uniform float max_opacity = 1;
uniform float min_opacity = 0;
uniform float flicker_speed = 1;

float random () {
    float r = 0.;
	for (int i = 0; i <= 10; i += 1)
		{
			r = abs(sin(sqrt(float(i * 2)) * TIME / 2.813)) - abs(cos(float(i) * flicker_speed *  TIME / 17.23));
		}
	return clamp(1.3 * r + (transparency), min_opacity, max_opacity);
}


void vertex() 
{
	UV = _depth_vertex(UV, TEXTURE_PIXEL_SIZE);
}

void fragment()
{

   	if (rotation) COLOR = _radial_fragment(UV, TEXTURE);
	COLOR.a = random();
}




// credit: FencerDevLog.