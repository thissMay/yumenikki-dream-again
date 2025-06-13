class_name State
extends Node

@export var transitionable: bool = true
var fsm: FSM

signal entered
signal exited

func _init() -> void:
	set_process(false)
	set_physics_process(false)

func enter_state() -> void: entered.emit()
func exit_state() -> void: exited.emit()

func physics_update(_delta: float) -> void: pass
func update(_delta: float) -> void: pass

func input(event: InputEvent) -> void: pass

# ----

func get_state_str() -> String: return self.name
