class_name StopMusic
extends ResourceCommand

@export var abrupt: bool = false

func _execute() -> void:
	Music.fadeout_current_music(true, abrupt)
