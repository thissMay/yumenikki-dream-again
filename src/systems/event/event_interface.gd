class_name Event extends Node
signal finished

@export var deferred: bool = false

# ---- virtual, concrete ----
func _ready() -> void: process_mode = Node.PROCESS_MODE_DISABLED
func _execute() -> void: finished.emit()
