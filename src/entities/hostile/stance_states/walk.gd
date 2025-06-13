extends SentientState

func physics_update(delta: float) -> void:
	if sentient.abs_velocity.length() <= 0: fsm._change_to_state("run")
	elif sentient.abs_velocity.length() > sentient.abs_velocity.length() * sentient.speed_multiplier: 
		fsm._change_to_state("run")
	
	sentient.speed_multiplier = 1
