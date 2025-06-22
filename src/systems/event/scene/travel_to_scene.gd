@tool
extends Event

@export var spawn_point: SpawnPoint
var interactable: Node2D

func _ready() -> void:	
	if !Engine.is_editor_hint(): 
		interactable = get_parent().interactable
		if !(get_parent() is Sequence) or get_parent().interactable == null: return
		super()
	
func _execute() -> void:
	super()
	if spawn_point == null: return 
	GameManager.EventManager.invoke_event("PLAYER_DOOR_USED", [spawn_point.connection_id])
	GameManager.change_scene_to(load(spawn_point.scene_path))
