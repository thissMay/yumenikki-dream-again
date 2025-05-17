@tool

class_name TeleportationDoor
extends Interactable

@export var spawn_point: Vector2 = Vector2(0, 20)
@export var spawn_dir: Vector2 = Vector2(0, 1)
@export var target_door: TeleportationDoor

func _ready() -> void:
	super()

func _draw() -> void:
	if Engine.is_editor_hint():
		var mado_sprite = preload("res://src/player/madotsuki/display/default/_RESET.png")
		var arrow_sprite = preload("res://src/images/arrow_direction.png")
		
		draw_texture(mado_sprite, spawn_point - mado_sprite.get_size() / 2, Color(1, 1, 1, .5))
		
func _process(delta: float) -> void:
	if Engine.is_editor_hint(): queue_redraw()

func _interact() -> void:
	if target_door != null:
		Game.scene_manager.get_curr_scene().on_unload_request()
		await GameManager.request_transition(ScreenTransition.fade_type.FADE_IN)
		
		PLInstance.teleport_player(target_door.get_spawn_point(), target_door.spawn_dir)
		PLInstance.get_pl().reparent(target_door.get_parent())
		
		Game.scene_manager.get_curr_scene().on_load_request()
		await GameManager.request_transition(ScreenTransition.fade_type.FADE_OUT)

func get_spawn_point() -> Vector2:
	return self.global_position + spawn_point
