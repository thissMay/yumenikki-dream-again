class_name SBComponentReceiver
extends Node2D

var sentient: SentientBase
var components: Array
var bypass: bool = false:
	set(_by):
		bypass = _by
		if _by: bypass_enabled.emit()
		else: bypass_lifted.emit()

signal bypass_enabled
signal bypass_lifted

func _ready() -> void:
	self.name = "sb_components"
func _setup(_sb: SentientBase) -> void: 
	components = self.get_children()
	
	for component in components: 
		if component and component is SBComponent: 
			component.sentient = _sb
			component._setup(_sb)

func _update(_delta: float) -> void:
	if !bypass:
		for component in components: 
			if component: component.update(_delta)
func _physics_update(_delta: float) -> void: 
	if !bypass:
		for component in components: 
			if component: component.physics_update(_delta)
func _input_pass(_event: InputEvent) -> void:
	if !bypass:
		for component in components: 
			if component: component.input_pass(_event)

func get_component_by_name(_name: String) -> SBComponent:
	for i in get_children():
		if i and i.name == _name:
			return i
			
	return null
func has_component_by_name(_name: String) -> bool:
	for i in get_children():
		if i and i.name == _name: return true
	return false

func set_bypass(_bypass: bool) -> void: bypass = _bypass
	
