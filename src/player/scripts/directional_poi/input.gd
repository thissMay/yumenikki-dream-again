class_name strat_dir_input
extends Strategy

func _physics_update(_delta: float, _context: Variant = null) -> void: 
	if PLInstance.get_pl():
		_context.position = (SentientController.get_input_vectors())
