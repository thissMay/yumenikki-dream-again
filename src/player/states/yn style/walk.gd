extends SentientState

func enter_state(s = null) -> void:
	(player as Player_YN).set_texture_using_sprite_sheet("walk")
	player.animation_manager.play_animation("normal/walk")
	player.noise_multi = 1
	
func update(_delta: float, s = null) -> void:
	player.look_at_dir(player.get_marker_direction())
	if player.velocity == Vector2.ZERO: player.force_change_state("idle")
	
func physics_update(_delta: float, s = null) -> void:
	player.get_behaviour()._walk(s, SentientController.get_input_vectors())

	if player.stamina < player.MAX_STAMINA and !player.is_exhausted:
		player.stamina += _delta * (player.stamina_regen / 1.2)

	
