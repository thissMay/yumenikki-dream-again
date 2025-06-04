extends Event

@export var node: Node
@export var new_parent: Node

func _execute() -> void:
	if node and new_parent:
		node.reparent(new_parent)
		finished.emit()
