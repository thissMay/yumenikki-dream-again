@tool

class_name Sequence extends Event
var order: Array
@export var ignore_finish_signal: bool = false

func _ready() -> void:
	order = get_children()	
	process_mode = Node.PROCESS_MODE_DISABLED
func _execute() -> void:
	for c in order:
		if c != null and c is Event: 
			if ignore_finish_signal: c._execute()
			else: await c._execute()
