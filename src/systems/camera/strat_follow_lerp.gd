class_name FollowStrategyLerp
extends CameraFollowStrategy

func _follow(_cam: CameraHolder, _origin: Vector2, _point: Vector2) -> void:
	final = _origin.lerp(_point, Game.get_real_delta() * follow_speed)
	_cam.global_position = final
