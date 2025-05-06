extends SentientState

func enter_state(s = null) -> void: 
	(player as Player_YN).set_texture_using_sprite_sheet("walk")
	player.animation_manager.play_animation("normal/walk")
	player.noise_multi = 0.2
func exit_state(s = null) -> void:
	player.noise_multi = player.NOISE_MULTI
	
func update(_delta: float, s = null) -> void:
	player.look_at_dir(player.get_marker_direction())
	
func physics_update(_delta: float, s = null) -> void:	
	if player.stamina < player.MAX_STAMINA:
		player.stamina += _delta * (player.stamina_regen / 1.5)

	player.get_behaviour()._sneak(s, SentientController.get_input_vectors())
