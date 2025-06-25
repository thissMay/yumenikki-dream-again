@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_autoload_singleton("NodeSaveService", "res://src/systems/game/node_save_service.gd")
	add_autoload_singleton("Game", "res://src/game/game.gd")
	
	add_autoload_singleton("GlobalPanoramaManager", "res://src/autoloads/panorama_system.gd")
	
	add_autoload_singleton("Global", "res://src/autoloads/global.gd")
	
	add_autoload_singleton("Music", "res://src/autoloads/bgm_player_music.gd")
	add_autoload_singleton("Ambience", "res://src/autoloads/bgm_player_amb.gd")
	add_autoload_singleton("AudioService", "res://src/autoloads/audio_service.gd")
	
	add_autoload_singleton("ScreenTransition", "res://src/autoloads/autoload_screentrans.tscn")

	

func _exit_tree() -> void:
	remove_autoload_singleton("NodeSaveService")
	remove_autoload_singleton("Game")
	
	remove_autoload_singleton("GlobalPanoramaManager")
	
	remove_autoload_singleton("Global")
	
	remove_autoload_singleton("Music")
	remove_autoload_singleton("Ambience")
	remove_autoload_singleton("AudioService")
	
	remove_autoload_singleton("ScreenTransition")
