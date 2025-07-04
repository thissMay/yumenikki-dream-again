extends Interactable

@export var connection_id: String = "default"
@export_file("*.tscn") var scene_path: String
@export var spawn_point: Vector2 = Vector2(0, 20)
@export var spawn_dir: Vector2 = Vector2(0, 1)

func _ready() -> void:
	super()
	self.add_to_group("spawn_points")

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_circle(spawn_point, 10, Color(Color.YELLOW, 0.35))

func _interact() -> void:
	super()
	GameManager.EventManager.invoke_event("PLAYER_DOOR_USED", [connection_id])
	GameManager.change_scene_to(load(scene_path))

func get_spawn_point() -> Vector2:
	return self.global_position + spawn_point
