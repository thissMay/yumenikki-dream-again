class_name StopMusic
extends ResourceEvent

@export var abrupt: bool = false

func _execute() -> void:
	Music.fadeout_current_music(true, abrupt)
