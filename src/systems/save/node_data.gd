class_name NodeData
extends Node

func _ready() -> void:
	add_to_group("node_save")
	
func save_data() -> Dictionary: return {}
func load_data(_scene: SceneNode) -> Error: return OK
