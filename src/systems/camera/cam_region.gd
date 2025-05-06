class_name CamRegion
extends Area2D

var region_priority: int = 0
var rect: CollisionShape2D

@export var enter_sequence: Sequence
@export var exit_sequence: Sequence

func _ready() -> void:
	set_collision_layer_value(32, true)
	set_collision_mask_value(32, true)
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	
	rect = $rect
	if rect.shape.size.x > 480: rect.shape.size.x = 480
	if rect.shape.size.y > 270: rect.shape.size.y = 270
		
	self.area_entered.connect(
		func(_area: Area2D): 
			if _area == PLInstance.get_pl().world_warp: CameraHolder.instance.set_target(rect)
			if enter_sequence: enter_sequence.execute())
	self.area_exited.connect(
		func(_area: Area2D): 
			if _area == PLInstance.get_pl().world_warp: CameraHolder.instance.set_target(CameraHolder.instance.prev_target)
			if exit_sequence: exit_sequence.execute())
