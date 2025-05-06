shader_type canvas_item;
render_mode blend_add;

uniform float transparency : hint_range(0.0, 1.0, 0.1) = 0;

void fragment() {COLOR.a = COLOR.a - transparency;}
