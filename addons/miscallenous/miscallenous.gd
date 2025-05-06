@tool
extends EditorPlugin

var inspector_plus = preload("res://addons/miscallenous/inspector_plus.gd").new()

func _enter_tree() -> void:
	add_custom_type(
		"GameScene", 
		"Node", 
		preload("res://src/systems/scenes/game/game_scene.gd"), 
		preload("res://src/images/editor/game_scene.png")
		)
	add_inspector_plugin(inspector_plus)
		
func _exit_tree() -> void:
	remove_custom_type("GameScene")
	remove_inspector_plugin(inspector_plus)
