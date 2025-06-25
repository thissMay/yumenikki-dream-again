extends Event

@export var node: Node
@export var new_process_mode: Node.ProcessMode

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	
func _execute() -> void:
	if node == null: return
	node.set_process_mode(new_process_mode)
	super()
