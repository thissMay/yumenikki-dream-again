class_name SwitchToSceneUsingData
extends ResourceCommand

@export var scene_data: SceneData
@export var spawn_id: String
@export_enum("BASE", "SESSION") var selection: int = 1

func _execute() -> void:
	Main.change_scene_to_via_data(scene_data, selection, spawn_id)
