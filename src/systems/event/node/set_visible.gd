extends Event

@export var node: Node
@export var visible: bool

func _execute() -> void:
	node.visible = visible
	finished.emit()
