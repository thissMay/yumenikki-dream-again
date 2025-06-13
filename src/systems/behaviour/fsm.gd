class_name FSM 
extends Node

signal state_changed(_new_state)
signal setup

var state_dict: Dictionary
var curr_state: State
@export var initial_state: State

func _init(init_state: State = null) -> void: initial_state = init_state

# --- initial ---
func _setup() -> void:
	for states in self.get_children():
		if states is State:
			states.fsm = self 
			state_dict[states.name.to_lower()] = states 
			
	curr_state = initial_state
	_enter_initial()
func _enter_initial() -> void:
	if curr_state != null: curr_state.enter_state()

func _change_to_state(new_state: StringName) -> void:
	if new_state != "" and _has_state(new_state):
		var newstate: State = state_dict.get(new_state.to_lower())
		if curr_state != newstate and newstate.transitionable:
			
			state_changed.emit(newstate)	
			
			curr_state.exit_state()
			curr_state = newstate
			curr_state.enter_state()
			

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
func _update(_delta: float,) -> void: 
	if curr_state != null: curr_state.update(_delta)
func _physics_update(_delta: float) -> void: 
	if curr_state != null: curr_state.physics_update(_delta)
func _input_pass(event: InputEvent,) -> void: 
	if curr_state != null: curr_state.input(event)
