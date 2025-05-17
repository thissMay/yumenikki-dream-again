@tool

class_name CameraRegion
extends Area2D

# --- sets the camera to the region area.

var region_priority: int = 0
var rect: CollisionShape2D
var marker: Marker2D

@export var instant_cam_switch: bool = false

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	
	rect = $rect
	marker = $marker
	
	if !Engine.is_editor_hint():
		set_collision_layer_value(32, true)
		set_collision_mask_value(32, true)
		
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
		
		if rect.shape.size.x > 480: rect.shape.size.x = 480
		if rect.shape.size.y > 270: rect.shape.size.y = 270
			
		self.area_entered.connect(
			func(_area: Area2D): 
				if _area == PLInstance.get_pl().world_warp: CameraHolder.instance.set_target(marker, instant_cam_switch))
		self.area_exited.connect(
			func(_area: Area2D): 
				if _area == PLInstance.get_pl().world_warp: CameraHolder.instance.set_target(CameraHolder.instance.prev_target))

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_rect(Rect2(marker.position - Vector2(240, 135), Vector2(480, 270)), Color.RED, false, 2)
	
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()
