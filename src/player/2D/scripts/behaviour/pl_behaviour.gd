class_name PLBehaviour
extends Resource

# ---- movement ----
func _idle		(_pl: Player, _delta: float) -> void:  pass

func _walk		(_pl: Player, _delta: float) -> void:  
	_pl.handle_direction(_pl.dir_input)
	_pl.noise_multi 		= _pl.values.walk_noise_multi
	
		
func _run		(_pl: Player, _delta: float) -> void:  
	_pl.handle_direction(_pl.vel_input)
	_pl.noise_multi 		= _pl.values.sprint_noise_multi
	_pl.speed_multiplier 	= _pl.values.sprint_multi

	
func _sneak		(_pl: Player, _delta: float) -> void: 	
	_pl.handle_direction(_pl.dir_input)
	_pl.noise_multi 		= _pl.values.sneak_noise_multi
	
	_pl.speed_multiplier = _pl.values.sneak_multi

func _climb		(_pl: Player, _delta: float) -> void: pass

# ---- miscallenous ----
func _interact	(_pl: Player, _choice: int) -> void: 
	_pl.components.get_component_by_name(Player_YN.Components.INTERACT).handle_interaction(_choice)
