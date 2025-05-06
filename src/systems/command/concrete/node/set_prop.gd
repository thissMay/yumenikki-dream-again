class_name SetProperty 
extends ResourceCommand

@export var node: NodePath
@export var prop: String
@export var value: int

func _execute() -> void: 
	if Global.get_node(node):
		Global.get_node(node).set_indexed(prop, value)
