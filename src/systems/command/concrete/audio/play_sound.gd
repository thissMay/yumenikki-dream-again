class_name PlaySound
extends ResourceCommand

@export var sound: AudioStreamWAV = null
@export var volume: float = 0
@export var pitch: float = 1

func _execute() -> void:
	AudioService.play_sound(sound, volume, pitch)
