class_name SwitchToScene
extends ResourceCommand

@export_file() var scene_path: String
func _execute() -> void:
	Main.change_scene_to(load(scene_path))
