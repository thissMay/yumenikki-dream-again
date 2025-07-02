class_name Event extends Node
signal finished

@export var deferred: bool = false
@export var wait_til_finished: bool = true

# ---- virtual, concrete ----
func _ready() -> void: process_mode = Node.PROCESS_MODE_DISABLED
func _execute() -> void: finished.emit.call_deferred()
