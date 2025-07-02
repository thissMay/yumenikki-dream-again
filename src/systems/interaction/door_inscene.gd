@tool

class_name TeleportationDoor
extends Interactable

@export_storage var spawn_point: SpawnPoint
@export var target_door: TeleportationDoor
@export var parallel: bool


func _setup() -> void:
	super()
	spawn_point = GlobalUtils.get_child_node_or_null(self, "spawn_point")
	if spawn_point == null:
		spawn_point = await GlobalUtils.add_child_node(self, SpawnPoint.new(), "spawn_point")
		

func _draw() -> void:
	if Engine.is_editor_hint():
		var mado_sprite = preload("res://src/player/madotsuki/display/default/_RESET.png")
		var arrow_sprite = preload("res://src/images/arrow_direction.png")
		
		if target_door != null:
			draw_line(Vector2.ZERO, target_door.global_position - self.global_position, Color.RED)
			target_door.parallel = parallel
			target_door.target_door = self if target_door.parallel else target_door.target_door	
			
func _process(delta: float) -> void:
	super(delta)
	if Engine.is_editor_hint(): 
		queue_redraw()
		if target_door == self: target_door = null

func _interact() -> void:
	if target_door != null and target_door.spawn_point:
		
		GameManager.EventManager.invoke_event("PLAYER_DOOR_TELEPORTATION")
		Game.scene_manager.get_curr_scene().on_unload_request()
		await GameManager.request_transition(ScreenTransition.fade_type.FADE_IN)
		
		print(target_door.spawn_point)
		Player.Instance.teleport_player(target_door.spawn_point.global_position, target_door.spawn_point.spawn_dir)
		Player.Instance.get_pl().reparent(target_door.get_parent())
		
		Game.scene_manager.get_curr_scene().on_load_request()
		GameManager.request_transition(ScreenTransition.fade_type.FADE_OUT)
	
