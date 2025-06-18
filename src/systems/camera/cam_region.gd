@tool

class_name CameraRegion
extends AreaRegion

# --- sets the camera to the region area.

@export var instant_cam_switch: bool = false

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(Rect2(marker.position - Vector2(240, 135), Vector2(480, 270)), Color.RED, false, 2)
	
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()
		
func _handle_player_enter() -> void:
	CameraHolder.instance.set_target(marker, instant_cam_switch)
	
func _handle_player_exit() -> void:
	CameraHolder.instance.set_target(CameraHolder.instance.prev_target)
