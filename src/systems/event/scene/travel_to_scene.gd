extends Event

@export var spawn_point: SpawnPoint
var interactable: Node2D

func _execute() -> void:
	super()
	if spawn_point == null: return 
	GameManager.EventManager.invoke_event("PLAYER_DOOR_USED", [spawn_point.connection_id])
	GameManager.change_scene_to(load(spawn_point.scene_path))
