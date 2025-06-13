extends SentientState

func physics_update(delta: float) -> void:
	if sentient.abs_velocity.length() <= 0: fsm._change_to_state("idle")
	sentient.speed_multiplier = 2
