class_name SBComponentReceiver
extends Node2D

var sentient: SentientBase
var components: Array

func _setup(_sb: SentientBase) -> void: 
	components = self.get_children()
	
	for component in components: 
		if component and component is SBComponent: 
			component.sentient = _sb
func _update(_delta: float) -> void:
	for component in components: 
		if component: component._update(_delta)
func _physics_update(_delta: float) -> void: 
	for component in components: 
		if component: component._physics_update(_delta)

func get_component_by_name(_name: String) -> SBComponent:
	for i in get_children():
		if i and i.name == _name:
			return i
			
	return null
