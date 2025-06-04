extends Event

@export var node: Component
@export var enable: bool

func _execute() -> void:
	(node as Component).set_active(enable)
	finished.emit()
