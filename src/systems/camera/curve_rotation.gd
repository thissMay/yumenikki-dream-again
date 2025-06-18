extends Component
@export var rot_curve: Curve
@export var rot_strength: float = 1.2

func _physics_update(_delta: float) -> void:
	if rot_curve:
		receiver.affector.marker.global_rotation_degrees = (
			lerpf(receiver.affector.marker.global_rotation_degrees, rot_strength * rot_curve.sample(receiver.affector.get_velocity().x), _delta * Global.TWEEN_SCALE))
	else:
		receiver.affector.marker.global_rotation_degrees = 0

func set_active(_active: bool = true) -> void:
	if _active == false:
		receiver.affector.marker.global_rotation_degrees = 0
	super(_active)

func _on_bypass_enabled() -> void: set_active(false)
func _on_bypass_lifted() -> void: set_active(true)
