shader_type canvas_item;
render_mode blend_disabled;

uniform float uv_rotation_speed = 5.;
uniform vec2 uv_rotation_pivot = vec2(0.5);

uniform vec2 uv_offset = vec2(0);
uniform float offset_strength = 1;

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

    COLOR = texture(TEXTURE, uv); // use calculated uv
}

// credit: FencerDevLog.