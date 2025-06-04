extends SentientState

func enter_state() -> void: 
	(sentient as Player_YN).set_texture_using_sprite_sheet("walk")
	sentient.animation_manager.play_animation("normal/walk")
	sentient.noise_multi = sentient.sneak_noise_mult
func exit_state() -> void:
	sentient.noise_multi = sentient.NOISE_MULTI
	
func update(_delta: float, ) -> void:
	sentient.look_at_dir(sentient.get_marker_direction())
	
func physics_update(_delta: float, ) -> void:	
	if sentient.stamina < sentient.MAX_STAMINA:
		sentient.stamina += _delta * (sentient.stamina_regen / 1.5)

	sentient.get_behaviour()._sneak(sentient, SentientController.get_input_vectors())
