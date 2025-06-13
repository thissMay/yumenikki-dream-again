extends SentientState
var library_path := "normal"

func enter_state() -> void: 
	(sentient as Player_YN).set_texture_using_sprite_sheet("walk")
	sentient.components.get_component_by_name("animation_manager").play_animation(str(library_path, '/', "walk"))
	sentient.noise_multi = sentient.sneak_noise_mult
	
	super()
func exit_state() -> void:
	sentient.noise_multi = 1
	super()
	
func update(_delta: float, ) -> void:
	sentient.look_at_dir(sentient.get_marker_direction())
	
func physics_update(_delta: float, ) -> void:	
	if sentient.stamina < sentient.MAX_STAMINA:
		sentient.stamina += _delta * (sentient.stamina_regen / 1.5)

	sentient.get_behaviour()._sneak(sentient, SentientController.get_input_vectors())
