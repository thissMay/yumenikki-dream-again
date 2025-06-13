class_name SBComponent
extends Node

var sentient: SentientBase
@export var active: bool = true

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func _setup(_sentient: SentientBase) -> void: sentient = _sentient
func _update(delta: float) -> void: pass
func _physics_update(delta: float) -> void: pass
func _input_pass(event: InputEvent) -> void: pass

func update(_delta: float) -> void:
	if active: _update(_delta)
func physics_update(_delta: float) -> void:
	if active: _physics_update(_delta)
func input_pass(event: InputEvent) -> void:
	if active: _input_pass(event)
