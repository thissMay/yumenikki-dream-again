extends Event

@export var scene_traversal: SceneTraversal
var interactable: Node2D

func _execute() -> void:
	super()
	if scene_traversal == null: return 
	
	GameManager.EventManager.invoke_event("PLAYER_DOOR_USED", [scene_traversal.connection_id])
	GameManager.change_scene_to(load(scene_traversal.scene_path))
