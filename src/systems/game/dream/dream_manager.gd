extends FSM

const DREAM_LEVEL_DIR := "res://src/levels/_dream"
const REAL_LEVEL_DIR := "res://src/levels/_real"

@onready var scene_changed_listener := EventListener.new(["SCENE_CHANGE_SUCCESS"], false, self)

func _setup() -> void:
	super()
	scene_changed_listener.do_on_notify(
		"SCENE_CHANGE_SUCCESS", 
		func(): 
			if Game.scene_manager.scene_node_packed == null: return
			var scene: String = Game.scene_manager.scene_node_packed.resource_path
			var scene_folder_path = scene.split("/")
			
			if "_dream" in scene_folder_path: 
				GameManager.EventManager.invoke_event("REALITY_DREAM")
				_change_to_state("dream")
			elif "+_real" in scene_folder_path: 
				GameManager.EventManager.invoke_event("REALITY_REAL")
				_change_to_state("real")
			else: 
				GameManager.EventManager.invoke_event("REALITY_NEITHER")
				_change_to_state("neutral"))
	scene_changed_listener.on_notify("SCENE_CHANGE_SUCCESS")
