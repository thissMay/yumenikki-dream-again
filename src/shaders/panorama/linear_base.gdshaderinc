uniform float transparency : hint_range(0, 1.0, 0.01) = 0;
uniform float dirX : hint_range(-1.0, 1.0, 0.1);
uniform float dirY : hint_range(-1.0, 1.0, 0.1);
uniform float scroll_speed : hint_range(0.0, .75, 0.01);

global uniform vec2 uv_offset;
uniform vec2 initial_uv_offset;
uniform float offset_strength;
uniform float offset_strength_x_influence = 1;
uniform float offset_strength_y_influence = 1;


vec2 _vertex(vec2 uv, vec2 _pixel_size, mat4 _mat)
{
	return ((_mat * vec4(uv, _pixel_size)).xy + ((uv_offset / 2.5) * (offset_strength * offset_strength_x_influence)));

}

vec4 _fragment(vec2 _uv, sampler2D _texture)
{
	vec2 scroll_dir = -vec2(dirX, dirY) * (TIME * scroll_speed / 2.) + (uv_offset * offset_strength) + initial_uv_offset;
	vec4 panorama = texture(_texture, _uv + scroll_dir);
	return panorama;
}
