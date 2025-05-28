class_name SentientVelCheckTeleport
extends Node

@export var condition: Entity.compass_headings
@export var speed_condition: float = 10

var region_check: SentientVelCheckRegion
@export var spawn_point: Vector2 = Vector2(0, 20)
@export var spawn_dir: Vector2 = Vector2(0, 1)
@export var target_point: Node2D

func _ready() -> void:
	region_check = get_parent()
	await region_check.ready
	if region_check != null and region_check is SentientVelCheckRegion:
		region_check.area_region.player_enter_handle.connect(func(_pl): region_check.update.connect(update))

func update() -> void:
	if region_check.sentient_dir == condition and region_check.sentient_vel.length() > speed_condition:
		if target_point != null:
			region_check.update.disconnect(update)
			Game.scene_manager.get_curr_scene().on_unload_request()
			await GameManager.request_transition(ScreenTransition.fade_type.FADE_IN)
			
			PLInstance.teleport_player(target_point.global_position, PLInstance.get_pl().direction)
			PLInstance.get_pl().reparent(target_point.get_parent())
			
			Game.scene_manager.get_curr_scene().on_load_request()
			await GameManager.request_transition(ScreenTransition.fade_type.FADE_OUT)
			
