@tool

class_name Sequence extends Event
var order: Array

func _ready() -> void:
	order = get_children()	

func _execute() -> void:
	for c in order:
		if  c != null and c is Event: 
			await c._execute()
