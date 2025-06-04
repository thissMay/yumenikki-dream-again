@tool

class_name AreaRegion
extends Area2D

# --- sets the camera to the region area.

var region_priority: int = 0
var rect: CollisionShape2D
var marker: Marker2D

@export var size: Vector2i

signal player_enter_handle(_pl)
signal player_exit_handle(_pl)

var parent: Node

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
	parent = get_parent()
	if parent != null and parent is CanvasItem: 
		parent.visibility_changed.connect(func(): rect.disabled = !(parent.visible and is_visible_in_tree()))
	self.visibility_changed.connect(func(): rect.disabled = !(self.visible and is_visible_in_tree()))
	self.set_process(false)
	
	self.process_mode = Node.PROCESS_MODE_ALWAYS

	
	if !Engine.is_editor_hint():
		set_collision_layer_value(32, true)
		set_collision_mask_value(32, true)
		
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
			
		self.area_entered.connect(handle_player_enter)
		self.area_exited.connect(handle_player_exit)
	
	self.set_process(true)
	self.rect.shape.size = size
			
func _handle_player_enter() -> void: pass
func _handle_player_exit() -> void: pass

func handle_player_enter(_pl: Area2D) -> void: 
	if _pl == PLInstance.get_pl().world_warp:
		_handle_player_enter()
		player_enter_handle.emit(PLInstance.get_pl() if PLInstance.get_pl() != null else null)
func handle_player_exit(_pl: Area2D) -> void: 
	if _pl == PLInstance.get_pl().world_warp:
		_handle_player_exit()
		player_exit_handle.emit(PLInstance.get_pl() if PLInstance.get_pl() != null else null)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		rect.shape.size = size
		
