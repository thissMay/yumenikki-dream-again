extends Event

@export var node: Node
@export var new_modulate: Color
@export var is_self_modulate: bool = false

func _execute() -> void: 
	if !node is CanvasItem: return
	if is_self_modulate: (node as CanvasItem).self_modulate = new_modulate 
	else: (node as CanvasItem).modulate = new_modulate 
	
	super()
