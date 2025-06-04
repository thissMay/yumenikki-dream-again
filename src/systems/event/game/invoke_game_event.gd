class_name InvokeEventID
extends Event

@export var event_id: String
@export var params: Array[Variant]

func _execute() -> void:  
	GameManager.EventManager.invoke_event(event_id, params)
	finished.emit()
