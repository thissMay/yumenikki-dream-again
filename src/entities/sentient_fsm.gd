class_name SentientFSM
extends FSM

var sentient: SentientBase
var animator: Node

func _setup(_sentient: SentientBase = null) -> void:
	sentient = _sentient
	
	for states in self.get_children():
		if states is SentientState:
			states.fsm = self 
			state_dict[states.name.to_lower()] = states 
			
			states.sentient = _sentient
			states.animator = animator
			
	curr_state = initial_state
	_enter_initial()
