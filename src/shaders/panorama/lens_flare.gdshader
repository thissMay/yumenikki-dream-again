shader_type canvas_item;
render_mode blend_add;

uniform float uv_rotation_speed = 5.;
uniform vec2 uv_rotation_pivot = vec2(0.5);

uniform vec2 uv_offset = vec2(0);
uniform float offset_strength = 1;

uniform float transparency = 0;

float random () {
    float r = 0.;
	for (int i = 0; i <= 10; i += 1)
		{
			r = abs(sin(sqrt(float(i * 2)) * TIME / 1.813)) - abs(cos(float(i) * TIME / 7.23));
		}
	return clamp(r + (transparency), 0.1, 1. - transparency);
}

mat2 get2dRotationMatrix(float angleRadians)
{
    float s = sin(angleRadians);
    float c = cos(angleRadians);
    return mat2(vec2(c, s), vec2(-s, c));
}

void fragment()
{
    vec2 uv = UV; // whatever your UV is
    uv -= floor(uv); // make it into [0.0, 1.0) x [0.0, 1.0) range
    uv -= uv_rotation_pivot; // move origin to the rotation pivot
    uv *= get2dRotationMatrix(radians(TIME * uv_rotation_speed)); // rotate
    uv += uv_rotation_pivot; // move origin back

    COLOR.rgba = texture(TEXTURE, uv).rgba; // use calculated uv
	COLOR.a = random();
}




// credit: FencerDevLog.