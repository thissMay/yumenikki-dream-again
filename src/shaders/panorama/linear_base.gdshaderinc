uniform float transparency : hint_range(0, 1.0, 0.01) = 0;
uniform float dirX : hint_range(-1.0, 1.0, 0.1);
uniform float dirY : hint_range(-1.0, 1.0, 0.1);
uniform float scroll_speed : hint_range(0.0, .75, 0.01);



#include "depth_base.gdshaderinc"


vec4 _fragment(vec2 _uv, sampler2D _texture)
{
	vec2 scroll_dir = -vec2(dirX, dirY) * (TIME * scroll_speed / 2.) + (uv_offset * offset_strength) + initial_uv_offset;
	vec4 panorama = texture(_texture, _uv + scroll_dir);
	return panorama;
}
