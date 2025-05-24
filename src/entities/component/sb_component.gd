class_name SBComponent
extends Node

var sentient: SentientBase

func _setup(_sentient: SentientBase) -> void: sentient = _sentient
func _update(delta: float) -> void: pass
func _physics_update(delta: float) -> void: pass
func _input_pass(event: InputEvent) -> void: pass
