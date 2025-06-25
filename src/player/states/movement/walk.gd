extends SentientState
var library_path := "normal"

func enter_state() -> void:
	(sentient as Player_YN).set_texture_using_sprite_sheet("walk")
	sentient.components.get_component_by_name("animation_manager").play_animation(str(library_path, '/', "walk"))
	sentient.noise_multi = sentient.walk_noise_mult
	
	super()
	
func update(_delta: float, ) -> void:
	sentient.look_at_dir(sentient.get_marker_direction())
	if sentient.velocity == Vector2.ZERO: sentient.force_change_state("idle")
	
func physics_update(_delta: float, ) -> void:
	sentient.get_behaviour()._walk(sentient, sentient.input)

	if sentient.stamina < sentient.MAX_STAMINA and !sentient.is_exhausted:
		sentient.stamina += _delta * (sentient.stamina_regen / 1.2)

	
