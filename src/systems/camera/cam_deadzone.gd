@tool

class_name CamDeadzone
extends CameraRegion

# --- clamps the camera to the deadzone rect.

var in_deadzone: bool = false

func _ready() -> void:
	super()
	if Engine.is_editor_hint(): set_physics_process(false)
	else: set_physics_process(true)
	
func _physics_process(delta: float) -> void:
	if in_deadzone:
		CameraHolder.instance.global_position = CameraHolder.instance.global_position.clamp(
				self.global_position - ((rect.shape as RectangleShape2D).size / 3),
				self.global_position + ((rect.shape as RectangleShape2D).size / 3)
				)
		
func _handle_player_enter() -> void: in_deadzone = true
func _handle_player_exit() -> void: in_deadzone = false
