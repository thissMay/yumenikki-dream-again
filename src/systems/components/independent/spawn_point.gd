@tool

class_name SpawnPoint
extends Node2D
	
@export_file("*.tscn") var scene_path: String
@export var connection_id: String = "default"
@export var parent_instead_of_self: Node
@export var as_sibling: bool = false
@export var spawn_dir: Vector2 = Vector2(0, 1)

@onready var spawn_texture: Texture2D = load("res://src/images/spawn_point.png")
	

func _ready() -> void:		
	set_process(true)
	if !Engine.is_editor_hint():
		self.add_to_group("spawn_points")
		set_process(false)
		
func _draw() -> void:
		draw_texture(
			spawn_texture, 
			-spawn_texture.get_size() / 2 - Vector2(0, 8), Color(modulate, 0.8))
func _process(delta: float) -> void:
	if Engine.is_editor_hint(): queue_redraw()
