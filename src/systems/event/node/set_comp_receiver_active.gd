extends Event

@export var node: ComponentReceiver
@export var enable: bool

func _execute() -> void:
	if node == null: return 
	(node as ComponentReceiver).set_bypass(enable)
	super()
