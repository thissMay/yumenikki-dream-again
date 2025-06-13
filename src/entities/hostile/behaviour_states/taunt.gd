extends SentientState

@export var stance_fsm: SentientFSM
@export var aggression_component: SBAggression

func enter_state() -> void: 
	#stance_fsm._change_to_state("idle")
	if aggression_component.suspicion >= aggression_component.min_chase_threshold:
		fsm._change_to_state("chase")
	else:
		fsm._change_to_state("observe")
