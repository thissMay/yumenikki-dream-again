extends SentientState

func enter_state() -> void: 

	(sentient as Player_YN).set_texture_using_sprite_sheet("run")
	sentient.animation_manager.play_animation("normal/run")
	sentient.noise_multi = sentient.run_noise_mult

func physics_update(_delta: float, ) -> void:
	sentient.get_behaviour()._run(sentient, SentientController.get_input_vectors())
 
	if sentient.is_exhausted or !transitionable: sentient.force_change_state("walk")
	if sentient.stamina > 0: sentient.stamina -= (sentient.stamina_drain * sentient.get_process_delta_time()) 	
	elif sentient.stamina < 0:
		sentient.force_change_state("walk")
		sentient.stamina_fsm._change_to_state("exhausted")
