class_name SceneTraversal
extends Node


@export_file("*.tscn") var scene_path: String
@export var connection_id: String = "default"
@export var spawn_point: SpawnPoint

func _ready() -> void:
	if spawn_point == null: return
