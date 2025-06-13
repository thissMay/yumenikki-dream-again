@tool

class_name Interactable
extends AreaRegion

@export_group("Flags")
@export var detectable: bool = true
@export var area: bool = false
@export var only_once: bool = false
@export var can_interact: bool = true

@export_group("Direction Threshold")
@export var dir_min: Vector2 = Vector2.LEFT: 
	set(_dir): 
		dir_min.x = clamp(_dir.x, -1, 1)
		dir_min.y = clamp(_dir.y, -1, 1)
@export var dir_max: Vector2 = Vector2.RIGHT: 
	set(_dir): 
		dir_max.x = clamp(_dir.x, -1, 1)
		dir_max.y = clamp(_dir.y, -1, 1)
@export var omni_dir: bool = true

@export_group("Misc.")
signal interacted

func _init() -> void:
	super()
	debug_colour = Color(0.9 ,0, 0.7, 0.3)
func _ready() -> void:	
	super() 
	
	if !Engine.is_editor_hint():
		self.set_collision_layer_value(2, true)
		self.set_collision_mask_value(3, true)
		
		set_area_mode(area)

func _setup() -> void:
	set_physics_process(false)
	set_process(false)

func _interact() -> void: pass
func interact() -> void:
	if only_once and can_interact:
		can_interact = false
		_interact()
		interacted.emit()
		
	elif can_interact:
		_interact()
		interacted.emit()

func set_area_mode(_area: bool, _include_detection: bool = true) -> void: 
	if _include_detection: detectable = !_area		

func _handle_player_enter() -> void: if area: self.interact()
func _handle_player_exit() -> void: pass
