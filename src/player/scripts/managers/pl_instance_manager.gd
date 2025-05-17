class_name PLInstance
extends Node

static var dir_look_mouse := strat_dir_mouse.new()
static var dir_look_input := strat_dir_input.new()

# ---- adrenaline and sanity ----
static var sanity: float = 100
static var adrenaline: float = 0

# ---- ----
static var def_emote

# ---- ----
static var curr_data: Dictionary
static var player: Player

static var inventory: Array
static var memoriams: Array
static var effects: Array

static var door_listener: EventListener
static var door_went_flag: bool = false

static var equipment_auto_apply: EventListener 

static var equipment_pending: PlayerEffect
static var item_pending: ItemData

static func setup() -> void: 	
	door_listener = EventListener.new(["PLAYER_DOOR_USED", "SCENE_CHANGE_SUCCESS"], true)
	door_listener.do_on_notify("PLAYER_DOOR_USED", func(): door_went_flag = true)
	door_listener.do_on_notify("SCENE_CHANGE_SUCCESS", func(): 
		for d : SceneDoor in Game.get_group_arr("doors"):
			if (
				load(d.scene_path) == Game.scene_manager.prev_scene_ps and 
				door_went_flag and
				GameManager.EventManager.get_event_param("PLAYER_DOOR_USED")[0] == d.connection_id):
					
					teleport_player(d.get_spawn_point(), d.spawn_dir, true)
					door_went_flag = false
		)

	equipment_auto_apply = EventListener.new(["SCENE_CHANGE_SUCCESS"], true)
	
	equipment_auto_apply.do_on_notify(
		"SCENE_CHANGE_SUCCESS",
		func(): 
			if get_pl():
				(get_pl() as Player_YN).equip(equipment_pending, true)
	)

# ---- player ----
static func set_active(_active: bool) -> void: 
	player.set_active(_active)
static func set_position(_pos: Vector2) -> void: 
	player.global_position = _pos


static func pl_exists() -> bool:
	return (get_pl() != null)
static func get_pl() -> Player:
	return player
static func get_pos() -> Vector2:
	if player != null: return player.global_position
	return Vector2.ZERO
static func is_moving() -> bool:
	if player != null: return player.is_moving
	return false

static func teleport_player(_pos: Vector2, _dir: Vector2, w_camera: bool = false) -> void:
	if PLInstance.get_pl():
		PLInstance.get_pl().global_position = _pos
		PLInstance.get_pl().set_dir(_dir)
		if w_camera and CameraHolder.instance.target == PLInstance.get_pl(): 
			CameraHolder.instance.global_position = PLInstance.get_pl().global_position
static func handle_player_world_warp(_pos: Vector2, _dir: Vector2) -> void:
	if PLInstance.get_pl():
		PLInstance.get_pl().global_position = _pos
		PLInstance.get_pl().set_dir(_dir)
		if CameraHolder.instance: 
			CameraHolder.instance.global_position = PLInstance.get_pl().global_position
# ---- data ----
static func stats_tostring() -> String:
	if player:
		return (
			str(
				'CAN RUN?: \t%s \n\n' 				% (player.can_run),
				'BASE SPEED: \t%s m/s \n' 			% (player.initial_speed),
				'SNEAK MULT: \t%s m/s \n' 			% (player.initial_speed * player.SNEAK_MULTI),
				'SPRINT MULT: \t%s m/s \n\n' 		% (player.initial_speed * player.SPRINT_MULTI),
				'STAM REGEN: \t%s stm/s \n'		% (player.STAMINA_REGEN),
				'STAM DECAY: \t%s stm/s \n'	% (player.STAMINA_DRAIN),
				)
			)
	else: return ""

static func load_data() -> Error: return OK
	
static func save_data() -> Error: 
	var data := {
		"data" : 
			{
			"sanity" : 0,
			"behaviour" : null,
			"direction" : Vector2(),
			},
		"inventory" : [],
		"memoriams" : [],
		"effects" : [],
	}
	return OK
