class_name ResetCamera extends ResourceEvent

@export var ease: Tween.EaseType = Tween.EASE_OUT
@export var trans: Tween.TransitionType = Tween.TRANS_EXPO
@export var duration: int = 1

func _execute() -> void:
	CameraHolder.instance.lerp_offset(Vector2.ZERO, ease, trans, duration)
	CameraHolder.instance.lerp_zoom(1, ease, trans, duration)
	
