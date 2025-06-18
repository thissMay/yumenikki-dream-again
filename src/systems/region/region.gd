@tool

class_name AreaRegion
extends Area2D

var region_priority: int = 0
var rect: CollisionShape2D
var marker: Marker2D

@export var size: Vector2i:
	set(_size): 
		size = abs(_size)	
		if Engine.is_editor_hint(): handle_shape_size(_size)
@export var shape: Shape2D: 
	set(_shape): 
		shape = _shape
		if Engine.is_editor_hint():
			rect.shape = _shape
@export var debug_colour: Color = Color(0, 0, 0, .3):
	set(_colour):
		if Engine.is_editor_hint():
			debug_colour = _colour
			rect.debug_color = _colour
		
signal player_enter_handle(_pl: Player)
signal player_exit_handle(_pl: Player)

func _init() -> void: 
	if get_node_or_null("rect") == null: 
		rect = CollisionShape2D.new()
		shape = RectangleShape2D.new()
		rect.shape = shape
		rect.name = "rect"
		self.add_child(rect)	
	else:
		shape = rect.shape
		
	if get_node_or_null("marker") == null:
		marker = Marker2D.new()
		marker.name = "marker"
		self.add_child(marker)
		
	rect.debug_color = Color(0.2 ,0, 0.7, 0.2)
func _ready() -> void:
	
	self.process_mode = Node.PROCESS_MODE_INHERIT
	self.visibility_changed.connect(func(): rect.disabled = !(self.visible and is_visible_in_tree()))
	self.set_process(false)
		
	rect.shape = shape
		
	if !Engine.is_editor_hint():
		rect.disabled = !(self.visible and is_visible_in_tree())
		
		set_collision_layer_value(32, true)
		set_collision_mask_value(32, true)
		
		set_collision_layer_value(1, false)
		set_collision_mask_value(1, false)
			
		self.area_entered.connect(handle_player_enter)
		self.area_exited.connect(handle_player_exit)
	
	self.set_process(true)
	_setup()

func _setup() -> void:
	pass

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

func handle_shape_size(_size: Vector2) -> void: 
	if shape is	RectangleShape2D: (shape as RectangleShape2D).size = _size
	if shape is	CircleShape2D: (shape as CircleShape2D).radius = _size.x
