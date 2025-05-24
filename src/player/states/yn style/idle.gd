extends SentientState

@export var pinch: PlayerAction

func enter_state(s = null) -> void: 
	(player as Player_YN).set_texture_using_sprite_sheet("idle")
	player.animation_manager.play_animation("normal/idle")
	player.noise_multi = Player.NOISE_MULTI
	player.velocity = Vector2.ZERO

func update(_delta: float, s = null) -> void:
	player.look_at_dir(player.get_marker_direction())

func physics_update(_delta: float, s = null) -> void:
	player.get_behaviour()._idle(s)
	if player.stamina < player.MAX_STAMINA and !player.is_exhausted:
		player.stamina += _delta * (player.stamina_regen)
	
func input(event: InputEvent, s = null) -> void: 
	if (Global.input["key_pressed"] == KEY_G and
		Global.input["held_down"]):
			player.perform_emote(player.emote)
	if (Global.input["key_pressed"] == KEY_Q and
		Global.input["held_down"]):
			player.perform_action(pinch)
