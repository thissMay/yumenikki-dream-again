class_name PlayMusic
extends Event

@export var music: AudioStreamOggVorbi
@export var volume: float = 0
@export var pitch: float = 1

func _execute() -> void:
	Music.play_sound(music)
	finished.emit()
