class_name Player
extends SentientBase

var input := Vector2(0, 0)

@export_file("*.tscn") var access_menu: String
@export var fsm: SentientFSM

#region ---- data variables ----

@export_group("Mobility Multiplier")
@export var walk_multiplier: float = WALK_MULTI
@export var sneak_multiplier: float = SNEAK_MULTI
@export var sprint_multiplier: float = SPRINT_MULTI
@export var exhaust_multiplier: float = EXHAUST_MULTI

@export_group("Stamina Modifier")
@export var stamina_drain: float = STAMINA_DRAIN
@export var stamina_regen: float = STAMINA_REGEN
var stamina: float = MAX_STAMINA:
	set(_stam):
		stamina = _stam
		GameManager.EventManager.invoke_event("PLAYER_STAMINA_CHANGE", [_stam])

var is_exhausted: bool = false
var can_run: bool = CAN_RUN

# ---- data constants ----
const CAN_RUN: bool = true

const WALK_MULTI: float = 1.25
const SNEAK_MULTI: float = 0.735
const SPRINT_MULTI: float = 2.9
const EXHAUST_MULTI: float = 0.9

const MAX_STAMINA := 5
const STAMINA_DRAIN: float = .78
const STAMINA_REGEN: float = 1

const WALK_NOISE_MULTI: float = 1
const RUN_NOISE_MULTI: float = 2.2
const SNEAK_NOISE_MULTI: float = 0.5

var walk_noise_mult: float = WALK_NOISE_MULTI
var run_noise_mult: float = RUN_NOISE_MULTI
var sneak_noise_mult: float =SNEAK_NOISE_MULTI
#endregion ---- data variables ----

# ---- initial ----
func _enter_tree() -> void: 
	Instance._pl = self
	GameManager.EventManager.invoke_event("PLAYER_UPDATED")
	
func _process(delta: float) -> void:
	super(delta)

class Instance:
	static var _pl: Player 
	
	static var inventory: Array
	static var effects: Array

	static var door_went_flag: bool = false

	static var door_listener: EventListener
	static var equipment_auto_apply: EventListener 

	static var equipment_pending: PLEffect

	static func setup() -> void: 	
		print("FUCK")
		
		door_listener = EventListener.new(["PLAYER_DOOR_USED", "SCENE_CHANGE_SUCCESS"], true)
		door_listener.do_on_notify("PLAYER_DOOR_USED", func(): door_went_flag = true)
		door_listener.do_on_notify("SCENE_CHANGE_SUCCESS", func(): 
			for points in Game.get_group_arr("spawn_points"):
				if (
					load(points.scene_path) == Game.scene_manager.prev_scene_ps and 
					door_went_flag and
					GameManager.EventManager.get_event_param("PLAYER_DOOR_USED")[0] == points.connection_id):
						
						teleport_player(points.get_spawn_point(), points.spawn_dir, true)
						if points.parent_instead_of_self != null:
							if points.as_sibling: _pl.reparent(points.parent_instead_of_self.get_parent())
							else: _pl.reparent(points.parent_instead_of_self)

						else:
							if points.as_sibling: _pl.reparent(points.get_parent())
							else: _pl.reparent(points)
						
						door_went_flag = false
			)

		equipment_auto_apply = EventListener.new(["SCENE_CHANGE_SUCCESS"], true)
		
		equipment_auto_apply.do_on_notify(
			"SCENE_CHANGE_SUCCESS",
			func(): 
				if get_pl():
					(get_pl() as Player_YN).equip(equipment_pending, true)
		)

	static func teleport_player(_pos: Vector2, _dir: Vector2, w_camera: bool = false) -> void:
		if get_pl():
			get_pl().global_position = _pos
			get_pl().set_dir.call_deferred(_dir)
			if w_camera and CameraHolder.instance.target == get_pl(): 
				CameraHolder.instance.global_position = get_pl().global_position
	static func handle_player_world_warp(_pos: Vector2, _dir: Vector2) -> void:
		if get_pl():
			get_pl().global_position = _pos
			get_pl().set_dir.call_deferred(_dir)
			if CameraHolder.instance: 
				CameraHolder.instance.global_position = get_pl().global_position
	
	static func pl_exists() -> bool: return (get_pl() != null)
	static func get_pl() -> Player: return _pl
	
	static func get_pos() -> Vector2:
		if pl_exists(): return _pl.global_position
		return Vector2.ZERO
	static func is_moving() -> bool:
		if pl_exists(): return _pl.is_moving
		return pl_exists()
	
	static func save_data() -> Error: 
		var data := {
			"data" : 
				{
					"innocent_killed" : 0,
					"hostile_killed" : 0,
				},
			"effects" : [],
		}
		return OK
