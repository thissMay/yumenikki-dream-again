class_name SetProperty 
extends ResourceEvent

var node: Node
@export var prop: String
@export var value: int

func _execute() -> void: 
	if node != null:
		node.set_indexed(prop, value)
