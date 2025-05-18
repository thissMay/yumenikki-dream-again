class_name MouseReactive
extends Component

@export var invert = false


@export var mouse_pos_relativity = 0.005
@export var min_pos_clamp: Vector2 = Vector2(0, 0)
@export var max_pos_clamp: Vector2 = Vector2(1, 1)


func _physics_update(delta: float) -> void:
	var i = -1 if invert else 1

	receiver.affector.position = receiver.affector.position.lerp(
		i * Vector2(Global.get_mouse_position_within_vp() * mouse_pos_relativity).clamp(min_pos_clamp, max_pos_clamp), 
		delta * 12)
		
	
