class_name EnableComponent
extends ResourceEvent

var node: Node
@export var enable: bool

func _execute() -> void:
	(node as Component).set_active(enable)
