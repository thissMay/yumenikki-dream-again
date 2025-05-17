class_name EnableComponentReceiver
extends ResourceEvent

var node: Node
@export var enable: bool

func _execute() -> void:
	(node as ComponentReceiver).set_bypass(enable)
