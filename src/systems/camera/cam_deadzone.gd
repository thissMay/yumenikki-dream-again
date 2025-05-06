class_name CamDeadzone
extends CamRegion

var in_deadzone: bool = false

func _ready() -> void:
	set_collision_layer_value(32, true)
	set_collision_mask_value(32, true)
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	rect = $rect
	rect.shape.size = rect_size 
	
	self.area_entered.connect(func(_area: Area2D): if _area == PLInstance.get_pl().world_warp: in_deadzone = true)
	self.area_exited.connect(func(_area: Area2D): if _area == PLInstance.get_pl().world_warp: in_deadzone = false)
	
func _physics_process(delta: float) -> void:
	if in_deadzone:
		print("mewo :3")
		CameraHolder.instance.global_position = CameraHolder.instance.global_position.clamp(
				self.global_position - (rect_size / 4),
				self.global_position + (rect_size / 4)
				)
