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

func get_component_by_name(_name: String) -> Component:
	for i in get_children():
		if i and i.name == _name:
			return i
			
	return null
func has_component_by_name(_name: String) -> bool:
	for i in get_children():
		if i != null and i is Component and  i.name == _name: return true
	return false
