extends Event

@export var node: Component
@export var enable: bool = false

func _execute() -> void:
	if node == null: return
	node.set_active(enable)
	super()
