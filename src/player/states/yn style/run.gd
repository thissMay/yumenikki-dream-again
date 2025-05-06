extends SentientState

func enter_state(s = null) -> void: 

	(player as Player_YN).set_texture_using_sprite_sheet("run")
	player.animation_manager.play_animation("normal/run")
	player.noise_multi = 2.2

func physics_update(_delta: float, s = null) -> void:
	player.get_behaviour()._run(s, SentientController.get_input_vectors())
	
	if player.is_exhausted: player.force_change_state("walk")
	if player.stamina > 0: player.stamina -= (player.stamina_drain * player.get_process_delta_time()) 	
	elif player.stamina < 0:
		player.force_change_state("walk")
		player.stamina_fsm._change_to_state("exhausted")
