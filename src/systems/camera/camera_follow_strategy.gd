class_name CameraFollowStrategy
extends Resource

var follow_speed := 4.0
var final: Vector2

func _setup(_cam: CameraHolder) -> void: pass
func _follow(_cam: CameraHolder,_origin: Vector2, _point: Vector2) -> void: 
	_cam.global_position = _point

func _changed() -> void: pass
