class_name TeleportationDoor
extends Interactable

@export var spawn_point: Vector2 = Vector2(0, 20)
@export var spawn_dir: Vector2 = Vector2(0, 1)
@export var target_door: TeleportationDoor

func _ready() -> void:
	super()

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_circle(spawn_point, 10, Color(Color.YELLOW, 0.35))

func _interact() -> void:
	await GameManager.request_transition(ScreenTransition.fade_type.FADE_IN)
	PLInstance.teleport_player(target_door.get_spawn_point(), spawn_dir, true)
	await GameManager.request_transition(ScreenTransition.fade_type.FADE_OUT)
	

func get_spawn_point() -> Vector2:
	return self.global_position + spawn_point
