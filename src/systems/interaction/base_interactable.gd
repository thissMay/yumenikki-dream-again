class_name Interactable
extends Area2D

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

func _ready() -> void:
	if !Engine.is_editor_hint():
		self.set_collision_layer_value(2, true)
		set_area_mode(area)

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
	match _area:
		true: 
			body_entered.connect(player_entered)
			if _include_detection: detectable = false
		false: 
			if body_entered.is_connected(player_entered): 
				body_entered.disconnect(player_entered)
			if _include_detection: detectable = true

func player_entered(pl: Node2D) -> void:
	if pl is Player: self.interact()
