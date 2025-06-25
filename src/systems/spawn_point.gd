@tool

class_name SpawnPoint
extends Node2D
	
@onready var spawn_texture: Texture2D = load("res://src/player/madotsuki/display/default/_RESET.png")
@export var parent_instead_of_self: Node
@export var as_sibling: bool = false
	
@export_file("*.tscn") var scene_path: String
@export var connection_id: String = "default"
@export var spawn_point: Vector2 = Vector2(0, 20)
@export var spawn_dir: Vector2 = Vector2(0, 1)

func _ready() -> void:		
	set_process(true)
	if !Engine.is_editor_hint():
		set_process(false)
		self.add_to_group("spawn_points")
		
func _draw() -> void:
	if Engine.is_editor_hint():
		draw_texture(
			spawn_texture, 
			spawn_point - spawn_texture.get_size() / 2, Color(modulate, 0.4))
func _process(delta: float) -> void:
	if Engine.is_editor_hint(): queue_redraw()

func get_spawn_point() -> Vector2:
	return self.global_position + spawn_point
