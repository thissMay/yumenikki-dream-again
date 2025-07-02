class_name StopMusic
extends Event

@export var abrupt: bool = false

func _execute() -> void:
	if !wait_til_finished: super()
	await Music.fade_out()
	if wait_til_finished: super()
