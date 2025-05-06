extends State

func enter_state(s = null) -> void: 
	PLInstance.get_pl().is_exhausted = true
func exit_state(s = null) -> void: 
	PLInstance.get_pl().is_exhausted = false
	PLInstance.get_pl().stamina = Player.MAX_STAMINA
	PLInstance.get_pl().sound_player.play_sound(preload("res://src/audio/se/se_breathe.wav"))
	
func physics_update(_delta: float, s = null) -> void:
	PLInstance.player.stamina += (_delta * (PLInstance.player.stamina_regen)) / 2
	if PLInstance.get_pl().stamina > 3.75: 
		fsm._change_to_state("normal")
