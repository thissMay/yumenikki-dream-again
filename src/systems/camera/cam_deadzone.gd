@tool

class_name CamDeadzone
extends CameraRegion

# --- clamps the camera to the deadzone rect.
var deadzone_strat: Strategy
var in_deadzone: bool = false

@onready var strat_square := strat_square_deadzone.new()

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
		if rect.shape is RectangleShape2D: deadzone_strat = strat_square
			
		deadzone_strat._physics_update(delta, rect)

		
func _handle_player_enter() -> void: in_deadzone = true
func _handle_player_exit() -> void: in_deadzone = false



class strat_square_deadzone:
	extends Strategy
	
	func _update(_delta: float, _context: Variant = null) -> void: 
		if _context.shape.size < Vector2(480, 270): _context.shape.size =  Vector2(480, 270)
		
	func _physics_update(_delta: float, _context: Variant = null) -> void: 
		CameraHolder.instance.global_position = CameraHolder.instance.global_position.clamp(
			_context.get_parent().global_position + (Vector2(Game.get_viewport_dimens().x, Game.get_viewport_dimens().y) / 2),
			_context.get_parent().global_position + (_context.shape.size - Vector2(Game.get_viewport_dimens().x, Game.get_viewport_dimens().y) / 2)
			)
