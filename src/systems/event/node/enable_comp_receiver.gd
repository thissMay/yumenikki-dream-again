extends Event

@export var node: Node
@export var enable: bool

func _execute() -> void:
	(node as ComponentReceiver).set_bypass(enable)
	finished.emit()
