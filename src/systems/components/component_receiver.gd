class_name ComponentReceiver
extends Node


var components: Array
@export var affector: Node
@export var bypass: bool = false:
	set(_by):
		bypass = _by
		if _by: bypass_enabled.emit()
		else: bypass_lifted.emit()

signal bypass_enabled
signal bypass_lifted

func _ready() -> void: components = get_children()
func set_bypass(_by: bool) -> void: bypass = _by
