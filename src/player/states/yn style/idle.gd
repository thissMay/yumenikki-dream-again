extends SentientState

@export var pinch: PlayerAction

func enter_state() -> void: 
	(sentient as Player_YN).set_texture_using_sprite_sheet("idle")
	sentient.animation_manager.play_animation("normal/idle")
	sentient.noise_multi = Player.NOISE_MULTI
	sentient.velocity = Vector2.ZERO

func update(_delta: float, ) -> void:
	sentient.look_at_dir(sentient.get_marker_direction())

func physics_update(_delta: float, ) -> void:
	sentient.get_behaviour()._idle(sentient)
	if sentient.stamina < sentient.MAX_STAMINA and !sentient.is_exhausted:
		sentient.stamina += _delta * (sentient.stamina_regen)
	
func input(event: InputEvent, ) -> void: 
	if (Global.input["key_pressed"] == KEY_G and
		Global.input["held_down"]):
			sentient.perform_emote(sentient.emote)
	if (Global.input["key_pressed"] == KEY_Q and
		Global.input["held_down"]):
			sentient.perform_action(pinch)
