class_name RadialMenu
extends Marker2D

var items: int = 5
var radius: float = 45

func _draw() -> void: 
	draw_circle(Vector2.ZERO, radius, Color.WHITE, true)
	for i in range(items):
		draw_line(Vector2.ZERO, radius * Vector2(2 / (PI * i), 2 / (PI * i)), Color.BLACK, 2)
	
