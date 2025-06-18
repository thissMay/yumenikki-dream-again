extends PLBehaviour

func _enter(_pl: Player) -> void: 
	(_pl as Player_YN).components.get_component_by_name("sprite_handler").set_dynamic_rot_multi(0.45)
	(_pl as Player_YN).stamina = Player.MAX_STAMINA
func _exit(_pl: Player) -> void:
	(_pl as Player_YN).components.get_component_by_name("sprite_handler").set_dynamic_rot_multi(SentientAnimator.DEFAULT_DYNAMIC_ROT_MULTI)

func _idle(_pl: Player) -> void: 
	_pl.handle_velocity(SentientController.get_input_vectors())
	if abs(_pl.velocity) > Vector2.ZERO: 
		_pl.force_change_state("run")

func _walk(_pl: Player, _dir: Vector2) -> void: 
	_pl.handle_velocity(_dir, _pl.walk_multiplier)
	if abs(_pl.velocity) > Vector2.ZERO: 
		_pl.force_change_state("run")


func _run(_pl: Player, _dir: Vector2) -> void:
	_pl.handle_velocity(_dir, _pl.sprint_multiplier)
	_pl.look_at_dir(SentientController.get_input_vectors())

	if abs(_pl.velocity.length()) <= 0:
		_pl.force_change_state("idle")
