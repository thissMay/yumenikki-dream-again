class_name PlayMusic
extends ResourceEvent

@export var music: AudioStreamOggVorbis = null
@export var volume: float = 0
@export var pitch: float = 1

func _execute() -> void:
	Music.play_sound(music)
