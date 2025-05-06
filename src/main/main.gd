@tool
class_name Main extends Control

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(Rect2i(Vector2i.ZERO, self.size), Color.SKY_BLUE, false, 1)
		draw_string(
			preload("res://fonts/FIRACODE-VARIABLEFONT_WGHT.TTF"), 
			Vector2(self.size.x / 2.085, self.size.y + 18), 
			str("X: ", self.size.x), 
			HORIZONTAL_ALIGNMENT_CENTER,
			-1,
			12)
		draw_string(
			preload("res://fonts/FIRACODE-VARIABLEFONT_WGHT.TTF"), 
			Vector2(self.size.x + 6, self.size.y / 2), 
			str("Y: ", self.size.y), 
			HORIZONTAL_ALIGNMENT_CENTER,
			-1,
			12)
func _process(delta: float) -> void: queue_redraw()
