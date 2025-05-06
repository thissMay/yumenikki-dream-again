class_name SwitchToRandomVariantScene
extends ResourceCommand

@export var scene_data: SceneData
@export var exclude_base: bool = false

func _execute() -> void:
	Main.change_to_random_select_scenes(scene_data, exclude_base)
