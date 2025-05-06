class_name strat_dir_mouse
extends Strategy

var actual_mouse_pos: Vector2
var registered_vector: Vector2

func _physics_update(_delta: float, _context: Variant = null) -> void: 
	actual_mouse_pos = Vector2(
			Global.get_mouse_position() / (Vector2(Game.viewport_width, Game.viewport_length)) * 2
			).normalized()
			
	registered_vector = actual_mouse_pos.round()
	
	if PLInstance.get_pl():
		_context.position = registered_vector
