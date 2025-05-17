class_name ShakeCam
extends ResourceEvent

@export var magnitude: float = 1
@export var speed: float = 1
@export var dur: float = 1

func _execute() -> void:
	if CameraHolder.instance: CameraHolder.instance.shake(magnitude, speed, dur)
	
