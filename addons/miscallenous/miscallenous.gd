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
		
	add_custom_type(
		"TeleportationDoor", 
		"Area2D", 
		preload("res://src/systems/interaction/door_inscene.gd"), 
		preload("res://src/images/editor/inscene_door.png")
		)
		
	add_custom_type(
		"Event", 
		"Node", 
		preload("res://src/systems/event/event_interface.gd"), 
		preload("res://src/images/editor/event_flag.png")
		)
	
	add_custom_type(
		"Sequence", 
		"Event", 
		preload("res://src/systems/sequence/sequence_interface.gd"), 
		preload("res://src/images/editor/sequence_flag.png")
		)
		
func _exit_tree() -> void:
	remove_custom_type("GameScene")
	remove_custom_type("CameraRegion")
	remove_custom_type("SentientBase")
	remove_custom_type("TeleportationDoor")
	remove_custom_type("Event")
	remove_custom_type("Sequence")
