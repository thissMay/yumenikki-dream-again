class_name OffsetCamera extends ResourceCommand

@export var offset: Vector2
@export var ease: Tween.EaseType = Tween.EASE_OUT
@export var trans: Tween.TransitionType = Tween.TRANS_EXPO
@export var duration: int = 1

func _execute() -> void:
	if CameraHolder.instance: 
		CameraHolder.instance.lerp_offset(offset, ease, trans, duration)
	
