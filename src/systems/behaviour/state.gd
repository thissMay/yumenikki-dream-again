class_name State
extends Node

@export var transitionable: bool = true
var fsm: FSM

func enter_state(s = null) -> void: pass
func exit_state(s = null) -> void: pass

func physics_update(_delta: float, s = null) -> void: pass
func update(_delta: float, s = null) -> void: pass

func input(event: InputEvent, s = null) -> void: pass

# ----

func get_state_str() -> String: return self.name
