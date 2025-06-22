extends State

func enter_state() -> void: 
	Player.Instance.get_pl().is_exhausted = true
func exit_state() -> void: 
	Player.Instance.get_pl().is_exhausted = false
	Player.Instance.get_pl().stamina = Player.MAX_STAMINA
	Player.Instance.get_pl().sound_player.play_sound(preload("res://src/audio/se/se_breathe.wav"))
	
func physics_update(_delta: float, ) -> void:
	Player.Instance.get_pl().components.get_component_by_name("mental_status").bpm = 120
	Player.Instance.get_pl().stamina += (_delta * (Player.Instance.get_pl().stamina_regen)) / 2
	if Player.Instance.get_pl().stamina > 0.5 * (Player.MAX_STAMINA): 
		fsm._change_to_state("normal")
