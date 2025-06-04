class_name PlaySound
extends Event

@export var emit_at_finish: bool = false
@export var sound: AudioStreamWAV = null
@export var volume: float = 0
@export var pitch: float = 1

func _execute() -> void:
	if emit_at_finish: await AudioService.play_sound(sound, volume, pitch)
	else: AudioService.play_sound(sound, volume, pitch)
		
	finished.emit()
