extends SentientState

func enter_state() -> void: 
	(sentient as SentientBase).velocity = Vector2.ZERO

func physics_update(delta: float) -> void:
	if sentient.abs_velocity.length() > 0: fsm._change_to_state("walk")
	
