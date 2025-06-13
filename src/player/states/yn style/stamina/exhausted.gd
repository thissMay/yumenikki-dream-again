extends State

func enter_state() -> void: 
	PLInstance.get_pl().is_exhausted = true
func exit_state() -> void: 
	PLInstance.get_pl().is_exhausted = false
	PLInstance.get_pl().stamina = Player.MAX_STAMINA
	PLInstance.get_pl().sound_player.play_sound(preload("res://src/audio/se/se_breathe.wav"))
	
func physics_update(_delta: float, ) -> void:
	PLInstance.get_pl().components.get_component_by_name("mental_status").bpm = 120
	PLInstance.player.stamina += (_delta * (PLInstance.player.stamina_regen)) / 2
	if PLInstance.get_pl().stamina > 0.5 * (Player.MAX_STAMINA): 
		fsm._change_to_state("normal")
