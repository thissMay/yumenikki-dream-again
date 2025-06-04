extends SentientState

func enter_state() -> void:
	(sentient as Player_YN).set_texture_using_sprite_sheet("walk")
	sentient.animation_manager.play_animation("normal/walk")
	sentient.noise_multi = sentient.walk_noise_mult
	
func update(_delta: float, ) -> void:
	sentient.look_at_dir(sentient.get_marker_direction())
	if sentient.velocity == Vector2.ZERO: sentient.force_change_state("idle")
	
func physics_update(_delta: float, ) -> void:
	sentient.get_behaviour()._walk(sentient, SentientController.get_input_vectors())

	if sentient.stamina < sentient.MAX_STAMINA and !sentient.is_exhausted:
		sentient.stamina += _delta * (sentient.stamina_regen / 1.2)

	
