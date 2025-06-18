extends SentientState
var library_path := "normal"
#var pinch: PLAction = preload("pinch")

func enter_state() -> void: 
	(sentient as Player_YN).set_texture_using_sprite_sheet("idle")
	sentient.components.get_component_by_name("animation_manager").play_animation(str(library_path, '/', "idle"))
	sentient.noise_multi = sentient.walk_noise_mult
	sentient.velocity = Vector2.ZERO

	super()

func update(_delta: float) -> void:
	sentient.look_at_dir(sentient.get_marker_direction())

func physics_update(_delta: float) -> void:
	sentient.get_behaviour()._idle(sentient)
	if sentient.stamina < sentient.MAX_STAMINA and !sentient.is_exhausted:
		sentient.stamina += _delta * (sentient.stamina_regen)
	
func input(event: InputEvent) -> void: 
	if sentient.components.get_component_by_name("input_manager").key_pressed(
		(event as InputEventKey).key_label, sentient.components.get_component_by_name("input_manager").keybinds.emote_key):
			sentient.perform_action(sentient.components.get_component_by_name("action_manager").emote)
	
	if (Global.input["key_pressed"] == KEY_Q and
		Global.input["held_down"]):
			pass
