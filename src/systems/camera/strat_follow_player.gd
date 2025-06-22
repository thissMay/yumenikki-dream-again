class_name FollowStrategyPlayer
extends CameraFollowStrategy

var player: Player
var calculated: Vector2

@export var look_ahead_distance: float = 10
var look_ahead: Vector2
var MAX_LOOK_AHEAD_PIXELS := Vector2(10, 10)

func _setup(_cam: CameraHolder) -> void:
	player = Player.Instance.get_pl()
func _follow(_cam: CameraHolder, origin: Vector2, point: Vector2) -> void:
	look_ahead = look_ahead.lerp(
		(player.get_marker_direction() * look_ahead_distance).clamp(-MAX_LOOK_AHEAD_PIXELS, MAX_LOOK_AHEAD_PIXELS), 
		Game.get_real_delta() * follow_speed)
	calculated = point + look_ahead.lerp(look_ahead, Game.get_real_delta())	
	final = calculated

	_cam.global_position = final
func _changed() -> void: look_ahead = Vector2.ZERO
