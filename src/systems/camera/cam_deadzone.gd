@tool

class_name CamDeadzone
extends CameraRegion

# --- clamps the camera to the deadzone rect.

var in_deadzone: bool = false

func _ready() -> void:
	super()
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	if Engine.is_editor_hint(): 
		set_physics_process(false)
		set_process(true)
	
	else: 
		set_physics_process(true)
		set_process(false)
	
func _physics_process(delta: float) -> void:
	if in_deadzone and CameraHolder.instance != null:
		CameraHolder.instance.global_position = CameraHolder.instance.global_position.clamp(
				self.global_position - ((shape as RectangleShape2D).size / 2 - Vector2(Game.get_viewport_dimens().x, Game.get_viewport_dimens().y) / 2),
				self.global_position + ((shape as RectangleShape2D).size / 2 - Vector2(Game.get_viewport_dimens().x, Game.get_viewport_dimens().y) / 2)
				)
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		size = size.clamp(Vector2(480, 270), size)
		rect.shape.size = size
		
func _handle_player_enter() -> void: in_deadzone = true
func _handle_player_exit() -> void: in_deadzone = false
