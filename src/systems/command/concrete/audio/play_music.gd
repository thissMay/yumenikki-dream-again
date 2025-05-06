class_name PlayMusic
extends ResourceCommand

@export var music: AudioStreamOggVorbis = null
@export var volume: float = 0
@export var pitch: float = 1

func _execute() -> void:
	Music.play_sound(music)
