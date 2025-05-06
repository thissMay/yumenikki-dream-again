class_name StrategistFSM
extends FSM

var prev_state: State

func _change_to_state(new_state: StringName, s = null) -> void:
	prev_state = curr_state
	super(new_state, s)
	
func _get_prev_state() -> State: return prev_state
func _get_prev_state_name() -> String: 
	if prev_state: return state_dict.find_key(prev_state)
	return ""
