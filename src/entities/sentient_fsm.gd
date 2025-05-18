class_name SentientFSM
extends FSM

var player: Player
var animator: Node

func _setup(_sentient: SentientBase = null) -> void:
	player = _sentient
	
	for states in self.get_children():
		if states is SentientState:
			states.fsm = self 
			state_dict[states.name.to_lower()] = states 
			
			states.player = player
			states.animator = animator
			
	curr_state = initial_state
	_enter_initial(_sentient)
