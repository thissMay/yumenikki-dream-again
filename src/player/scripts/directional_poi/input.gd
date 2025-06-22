class_name strat_dir_input
extends Strategy

func _physics_update(_delta: float, _context: Variant = null) -> void: 
	if Player.Instance.get_pl():
		_context.position = (Player.Instance.get_pl().velocity.normalized())
