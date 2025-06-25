extends SentientState

func physics_update(delta: float) -> void:
	if sentient.speed <= 0: fsm._change_to_state("idle")
	elif sentient.speed > sentient.speed * sentient.speed_multiplier: 
		fsm._change_to_state("run")
	
	sentient.speed_multiplier = 1
