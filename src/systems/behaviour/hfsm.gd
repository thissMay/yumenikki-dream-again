class_name HFSM
extends State

signal fsm_changed(_new_state)

var fsm_dict: Dictionary
var curr_fsm: FSM
@export var initial_fsm: FSM


# --- fsm behaviour
func _setup() -> void:
	for fsm in self.get_children():
		if fsm is FSM:
			fsm_dict[fsm.name.to_lower()] = fsm 
			fsm._setup()
		
	if initial_fsm != null: curr_fsm = initial_fsm
			

func _init(init_fsm: FSM = null) -> void: 
	super()
	initial_fsm = init_fsm
func _change_to_fsm(_new: StringName) -> void: 
	if _new != "" and _has_fsm(_new):
		var new_fsm: FSM = fsm_dict.get(_new.to_lower())
		if curr_fsm != new_fsm:
			
			fsm_changed.emit(new_fsm)	
			
			curr_fsm.exit_state()
			curr_fsm = new_fsm
			curr_fsm.enter_state()

	if curr_fsm != null: curr_fsm._setup()

# --- fsm helper methods
func _has_fsm(_fsm_name: String) -> bool: return _fsm_name in fsm_dict

# --- state behaviour
func enter_state() -> void: super()
func exit_state() -> void: super()

func _change_to_state(_new: StringName) -> void: curr_fsm._change_to_state(_new)

func _get_state(state_name: StringName) -> State:
	if curr_fsm._has_state(state_name.to_lower()): return curr_fsm.state_dict[state_name.to_lower()] 
	return null
func _get_curr_state() -> State: 
	return curr_fsm.curr_state
func _get_curr_state_name() -> String: 
	return curr_fsm.state_dict.find_key(curr_fsm.curr_state)

func update(_delta: float) -> void:		 if curr_fsm != null: curr_fsm._update(_delta)
func physics_update(_delta: float) -> void: if curr_fsm != null: curr_fsm._physics_update(_delta)
func input(event: InputEvent) -> void: if curr_fsm != null: curr_fsm._input_pass(event)
	
