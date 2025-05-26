class_name CamDeadzone
extends CameraRegion

var in_deadzone: bool = false

func _ready() -> void:
	set_collision_layer_value(32, true)
	set_collision_mask_value(32, true)
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	rect = $rect
	if (rect.shape as RectangleShape2D).size.length() <= Vector2(500, 300).length():
		(rect.shape as RectangleShape2D).size = Vector2(500, 300)
	
	self.area_entered.connect(func(_area: Area2D): if _area == PLInstance.get_pl().world_warp: in_deadzone = true)
	self.area_exited.connect(func(_area: Area2D): if _area == PLInstance.get_pl().world_warp: in_deadzone = false)
	
func _physics_process(delta: float) -> void:
	if in_deadzone:
		CameraHolder.instance.global_position = CameraHolder.instance.global_position.clamp(
				self.global_position - ((rect.shape as RectangleShape2D).size / 4),
				self.global_position + ((rect.shape as RectangleShape2D).size / 4)
				)
