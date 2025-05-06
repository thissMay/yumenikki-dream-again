class_name ZoomCamera extends ResourceCommand

@export var zoom: float = 1
@export var ease: Tween.EaseType = Tween.EASE_OUT
@export var trans: Tween.TransitionType = Tween.TRANS_EXPO
@export var duration: int = 1		

func _execute() -> void:
	if CameraHolder.instance: 
		CameraHolder.instance.lerp_zoom(zoom, ease, trans, duration)
	
