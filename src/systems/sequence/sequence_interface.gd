@tool

class_name Sequence extends Event
var order: Array

func _ready() -> void:
	order = get_children()	

func _execute() -> void:
	for event in order:
		if event != null and event is Event:
			(event as Event)._execute() 
			print(event)
			await event.finished
