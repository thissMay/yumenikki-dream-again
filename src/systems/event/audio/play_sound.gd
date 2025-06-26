class_name PlaySound
extends Event

@export var sound: AudioStreamWAV = null
@export var volume: float = 1
@export var pitch: float = 1
@export var wait_til_finished: bool = false

func _execute() -> void:
	if !wait_til_finished: super()
	await AudioService.play_sound(sound, volume, pitch)
	if wait_til_finished: super()
