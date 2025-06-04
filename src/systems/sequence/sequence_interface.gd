@icon("res://src/images/editor/sequence_flag.png")
@tool

class_name Sequence extends Event
var order: Array
@export var ignore_finished_signal: bool = false

func _ready() -> void:
	order = get_children()	
	process_mode = Node.PROCESS_MODE_DISABLED

func _execute() -> void:
	for c in order:
		if c != null and c is Event: 
			await c._execute()
