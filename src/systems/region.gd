@tool

class_name AreaRegion
extends Area2D

# --- sets the camera to the region area.

var region_priority: int = 0
var rect: CollisionShape2D
var marker: Marker2D

@export var size: Vector2i

signal player_enter_handle
signal player_exit_handle

func _init() -> void: 
	if get_node_or_null("rect") == null: 
		rect = CollisionShape2D.new()
		rect.shape = RectangleShape2D.new()
		rect.name = "rect"
		self.add_child(rect)	
	if get_node_or_null("marker") == null:
		marker = Marker2D.new()
		marker.name = "marker"
		self.add_child(marker)

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	self.set_process(false)

	if !Engine.is_editor_hint():
		set_collision_layer_value(32, true)
		set_collision_mask_value(32, true)
		
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
			
		self.area_entered.connect(handle_player_enter)
		self.area_exited.connect(handle_player_exit)
	
	self.set_process(true)
	rect.shape.size = size
			
func _handle_player_enter() -> void: pass
func _handle_player_exit() -> void: pass

func handle_player_enter(_pl: Area2D) -> void: 
	_handle_player_enter()
	player_enter_handle.emit()
func handle_player_exit(_pl: Area2D) -> void: 
	_handle_player_exit()
	player_exit_handle.emit()

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		rect.shape.size = size
		
