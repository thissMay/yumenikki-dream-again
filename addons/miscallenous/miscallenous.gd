@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_custom_type(
		"GameScene", 
		"Node2D", 
		preload("res://src/systems/scenes/game/game_scene.gd"), 
		preload("res://src/images/editor/game_scene.png")
		)
	add_custom_type(
		"CameraRegion", 
		"Area2D", 
		preload("res://src/systems/camera/cam_region.gd"), 
		preload("res://src/images/editor/cam_region.png")
		)
		
	add_custom_type(
		"SentientBase", 
		"CharacterBody2D", 
		preload("res://src/entities/sentient_base.gd"), 
		preload("res://src/images/editor/sentient_base.png")
		)
		
func _exit_tree() -> void:
	remove_custom_type("GameScene")
	remove_custom_type("CameraRegion")
	remove_custom_type("SentientBase")
