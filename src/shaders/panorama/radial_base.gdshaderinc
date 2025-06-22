
uniform float uv_rotation_speed = 5.;
uniform vec2 uv_rotation_pivot = vec2(0.5);


mat2 get2dRotationMatrix(float angleRadians)
{
    float s = sin(angleRadians);
    float c = cos(angleRadians);
    return mat2(vec2(c, s), vec2(s, -c));
}

vec4 _radial_fragment(vec2 _uv, sampler2D _texture)
{
    _uv -= uv_rotation_pivot; // move origin to the rotation pivot
    _uv *= get2dRotationMatrix(radians(TIME * uv_rotation_speed)); // rotate
    _uv += uv_rotation_pivot; // move origin back

    return texture(_texture, _uv); // use calculated uv
}

// credit: FencerDevLog.