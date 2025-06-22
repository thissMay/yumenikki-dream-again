class_name ComponentReceiver
extends Node

var components: Array
@export var affector: Node
@export var bypass: bool = false:
	set(_by):
		bypass = _by
		if _by: bypass_enabled.emit()
		else: bypass_lifted.emit()
@export var independent: bool = false

signal bypass_enabled
signal bypass_lifted

func _ready() -> void: 
	components = get_children()
	set_independent(independent)
	for component in components: 
		if component and component is Component: component._setup()
func set_bypass(_by: bool) -> void: bypass = _by

func _process(delta: float) -> void: _update(delta)
func _physics_process(delta: float) -> void: _physics_update(delta)

func _update(_delta: float) -> void:
	if bypass: return
	for component in components: 
		if component != null and component is Component: component._update(_delta)
func _physics_update(_delta: float) -> void: 
	if bypass: return
	for component in components: 
		if component != null and component is Component: 
			component._physics_update(_delta)

func set_independent(_independ: bool) -> void:
	match _independ:
		true: 
			set_process(true)
			set_physics_process(true)
		false: 
			set_process(false)
			set_physics_process(false)

func get_component_by_name(_name: String) -> Component:
	for i in get_children():
		if i and i.name == _name:
			return i
			
	return null
func has_component_by_name(_name: String) -> bool:
	for i in get_children():
		if i != null and i is Component and  i.name == _name: return true
	return false
