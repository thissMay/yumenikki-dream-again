class_name FSM 
extends Node

signal state_changed

var state_dict: Dictionary
var curr_state: State
@export var initial_state: State

func _init(init_state: State = null) -> void: initial_state = init_state

# --- initial ---
func _setup(s = null) -> void:
	for states in self.get_children():
		if states is State:
			states.fsm = self 
			state_dict[states.name.to_lower()] = states 
			
	curr_state = initial_state
	_enter_initial(s)
func _enter_initial(s = null) -> void:
	if curr_state != null: curr_state.enter_state(s)

func _change_to_state(new_state: StringName, s = null) -> void:
	if new_state != "" and _has_state(new_state):
		var newstate: State = state_dict.get(new_state.to_lower())
		if curr_state != newstate and newstate.transitionable:
			
			curr_state.exit_state(s)
			curr_state = newstate
			curr_state.enter_state(s)
			
			state_changed.emit()	

# --- state checks + getter --- 
func _has_state(state_name: StringName) -> bool:
	return state_name in state_dict
func _is_in_state(state_name: StringName) -> bool:
	if curr_state == state_dict.get(state_name.to_lower()): return true
	return false

func _get_state(state_name: StringName) -> State:
	if _has_state(state_name.to_lower()): return state_dict[state_name.to_lower()] 
	return
func _get_curr_state() -> State: return curr_state
func _get_curr_state_name() -> String: return state_dict.find_key(curr_state)

# --- dependent update / process --- 
func _update(_delta: float, s = null) -> void: 
	if curr_state != null: curr_state.update(_delta, s)
func _physics_update(_delta: float, s = null) -> void: 
	if curr_state != null: curr_state.physics_update(_delta, s)
func _input_pass(event: InputEvent, s = null) -> void: 
	if curr_state != null: curr_state.input(event, s)
