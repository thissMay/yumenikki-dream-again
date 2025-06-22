class_name GameManager extends Node

## this is meant for when the actual game is played, ONLY under this gamemanager instance.
## although I could go about doing an autoload, it would seem to be less able for dependency injection.
## and it would be code heavy, which would be VERY VERY prone to error. 
const PRE_GAME_SCENES := [
	"res://src/scenes/debug_preload.tscn",
	"res://src/scenes/pre_menu.tscn",
	"res://src/levels/menu/level.tscn"
	]

# ---- ----
static var bloom: bool = false

static var global_screen_effect: WorldEnvironment
static var instance

# ---- process parents ----
static var pausable_parent: CanvasLayer
static var always_parent: CanvasLayer

# ---- UI ----
static var player_hud: PLHUD
static var options: IngameSettings
static var ui_parent: CanvasLayer

# ---- cinematic ----
static var cinematic_ui: CanvasLayer
static var cinematic_bars: TextureRect
static var cb_tween: Tween

# ---- components
static var game_fsm: StrategistFSM


# ---- internal setup ----
func _ready() -> void:
	instance = self
	Game.game_manager = self
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	
func _input(event: InputEvent) -> void:
	if game_fsm: game_fsm._input_pass(event)
func setup() -> void:
	player_hud = PLHUD.instance
	
	global_screen_effect = get_node("global_screen_effect")
	pausable_parent = get_node("pausable")
	always_parent = get_node("always")
	ui_parent = get_node("always/ui")
	game_fsm = get_node("fsm")
	
	options = $always/pause
	
	cinematic_ui = $always/cinematic
	cinematic_bars = $always/cinematic/cinematic_bars

	game_fsm._setup()
	
	pausable_parent.process_mode = Node.PROCESS_MODE_PAUSABLE
	always_parent.process_mode = Node.PROCESS_MODE_ALWAYS
	
	cinematic_bars.position.y = -45
	cinematic_bars.size.y = 360
	
	if Game.scene_manager.scene_node_packed:  
		if !Game.scene_manager.scene_node_packed.resource_path in PRE_GAME_SCENES: change_to_state("active")
		else: change_to_state("pregame")
	
	global_screen_effect.environment.glow_enabled = bloom
	
	Player.Instance.setup()

# ---- game functionality ----
static func pause_options(_pause: bool = true) -> void:
	if _pause: change_to_state("pause")
	else: change_to_state(game_fsm._get_prev_state_name())
static func pause(_pause: bool = true) -> void:
	if _pause: Game.Application.pause()
	else: Game.Application.resume()
	
# ---- secondary scene handling (instead of using scenemanager directly) ----
static func get_curr_scene() -> void: Game.scene_manager.scene_node
static func unload_curr_scene() -> void: Game.scene_manager.unload_current_scene()
static func unload_scene(scene: SceneNode) -> void: Game.scene_manager.unload_scene(scene)
static func change_scene_to(_new: PackedScene) -> void: 
	if _new == null: return
	if instance: Game.scene_manager.change_scene_to(_new, pausable_parent)
	else: Game.scene_manager.change_scene_to(_new, Global)
					
# ---- UI stuff ---- 
static func set_ui_visibility(_visible: bool) -> void:
	ui_parent.visible = _visible 

static func set_cinematic_bars(_active: bool) -> void: 
	if cb_tween != null: cb_tween.kill()
	cb_tween = cinematic_ui.create_tween()
	cb_tween.set_parallel()
	cb_tween.set_ease(Tween.EASE_OUT)
	cb_tween.set_trans(Tween.TRANS_EXPO)
	
	match _active:
		true:
			cinematic_ui.visible = _active
			cb_tween.tween_property(cinematic_bars, "size:y", 270, 1)
			cb_tween.tween_property(cinematic_bars, "position:y", 0, 1)
		false:
			cb_tween.tween_property(cinematic_bars, "size:y", 360, 1)
			cb_tween.tween_property(cinematic_bars, "position:y", -45, 1)
			await cb_tween.finished
			cinematic_ui.visible = false
static func show_options(_visible: bool) -> void:
	options.visible = _visible

# ---- state based stuff ----
static func change_to_state(new_state: String) -> void: game_fsm._change_to_state(new_state)
static func is_in_state(state: String) -> bool: return game_fsm._is_in_state(state)
static func request_transition(_fade_type: ScreenTransition.fade_type) -> void:
	await Game.main_tree.physics_frame
	await ScreenTransition.request_transition(_fade_type)

# ---- message display manager ----
#static func open_message(
	#_type: MessageDisplay,
	#_texts: Array[String], 
	#_interruptive: bool = false, 
	#_sound: AudioStreamWAV = load("res://src/audio/se/se_talk.wav"),
	#_speed: int = 1,
	#_reset: bool = true, 
	#_pos: Vector2 = Vector2(Game.viewport_width / 2, Game.viewport_length - 110)
	#) -> void: 
		#message_display_manager.open_message_display(_type, _texts, _interruptive, _sound, _speed, _reset, _pos)

# ---- events
# the dictionary consists of the event name and a dictionary that contains: 1) id and 2) subscribers.
# 1) is self explanatory.
# 2) are going to contain callables itself to call them whenever needed.

# the only downside however, is no matter what callable is subscribed to what event
# the event will invoke and call all callables with no exceptions and conditions.
class EventManager:
	static func add_listener(_listener: EventListener, _id: String) -> void:
		if !(_id in GameManager.event_ids): create_event(_id)
		GameManager.event_ids[_id]["subscribers"].append(_listener)
		
	static func remove_listener(_listener: EventListener, _id: String) -> void:
		if !(_id in GameManager.event_ids): create_event(_id)
		if  GameManager.event_ids[_id]["subscribers"].find(_listener) != -1:
			GameManager.event_ids[_id]["subscribers"].remove_at(
				GameManager.event_ids[_id]["subscribers"].find(_listener)
				)
	static func create_event(_id: String) -> void:
		GameManager.event_ids[_id] = {"subscribers" : [], "params" : []}
			
	static func invoke_event(_id: String, _params := []) -> void: 
		if !(_id in GameManager.event_ids): create_event(_id)
		GameManager.event_ids[_id]["params"] = _params

		for i in range((GameManager.event_ids[_id]["subscribers"] as Array[EventListener]).size()):
			if GameManager.event_ids[_id]["subscribers"][i].is_valid_listener: 
				GameManager.event_ids[_id]["subscribers"][i].on_notify.call_deferred(_id)
			else: 
				remove_listener(GameManager.event_ids[_id]["subscribers"][i], _id)
	static func get_event_param(_id: String) -> Array[Variant]:
		if !(_id in GameManager.event_ids): create_event(_id)
		return GameManager.event_ids[_id]["params"]

	static func return_all_listeners(_id: String) -> Array[EventListener]: 
		if !(_id in GameManager.event_ids): create_event(_id)
		return GameManager.event_ids[_id]["subscribers"] as Array[EventListener]
		
static var event_ids := {
	# ---- game events -----
	"GAME_MENU" : {
		"subscribers" : [],
		"params" : []},
	"GAME_PAUSE" : {
		"subscribers" : [],
		"params" : []},
	"GAME_CUTSCENE" : {
		"subscribers" : [],
		"params" : []},
	"GAME_ACTIVE" : {
		"subscribers" : [],
		"params" : []},
	"GAME_FILE_SAVE" : {
		"subscribers" : [],
		"params" : []},
	"GAME_CONFIG_SAVE" : {
		"subscribers" : [],
		"params" : []},
	
	# ---- reality states -----
	"REALITY_REAL" : {
		"subscribers" : [],
		"params" : []},
	"REALITY_DREAM" : {
		"subscribers" : [],
		"params" : []},
	"REALITY_NEITHER" : {
		"subscribers" : [],
		"params" : []},
	
	# ---- cutscenes -----
	"CUTSCENE_START" : {
		"subscribers" : [],
		"params" : []},
	"CUTSCENE_END" : {
		"subscribers" : [],
		"params" : []},
	"CUTSCENE_TEMP-START" : {
		"subscribers" : [],
		"params" : []},
	"CUTSCENE_TEMP-END" : {
		"subscribers" : [],
		"params" : []},
	
	# ---- player ----
	"PLAYER_UPDATED" : {
		"subscribers" : [],
		"params" : []},
	
	"PLAYER_MOVE" : {
		"subscribers" : [],
		"params" : []},
	"PLAYER_ACTION" : {
		"subscribers" : [],
		"params" : []},
	"PLAYER_EMOTE" : {
		"subscribers" : [],
		"params" : []},
	"PLAYER_INTERACT" : {
		"subscribers" : [],
		"params" : []},
	"PLAYER_HURT" : {
		"subscribers" : [],
		"params" : []},
	"PLAYER_STAMINA_CHANGE" : {
		"subscribers" : [],
		"params" : []},
	"PLAYER_WAKE-UP" : {
		"subscribers" : [],
		"params" : []},
	
	"PLAYER_EQUIP" : {
		"subscribers" : [],
		"params" : []},
	"PLAYER_DEEQUIP" : {
		"subscribers" : [],
		"params" : []},

	"PLAYER_EFFECT_FOUND" : {
		"subscribers" : [],
		"params" : []},
	"PLAYER_EFFECT_DISCARD" : {
		"subscribers" : [],
		"params" : []},
		
	"PLAYER_DOOR_TELEPORTATION" : {
		"subscribers" : [],
		"params" : []},
		
	"PLAYER_DOOR_USED" : {
		"subscribers" : [],
		"params" : []},
	"PLAYER_SANITY_CHANGE" : {
		"subscribers" : [],
		"params" : []},
	"PLAYER_ADRENALINE_CHANGE" : {
		"subscribers" : [],
		"params" : []},	
	

	# ---- chase events -----
	"PRECHASE_ACTIVE" : {
		"subscribers" : [],
		"params" : []},
	"PRECHASE_FINISH" : {
		"subscribers" : [],
		"params" : []},
	"CHASE_ACTIVE" : {
		"subscribers" : [],
		"params" : []},
	"CHASE_FINISH" : {
		"subscribers" : [],
		"params" : []},

	# ---- scene change invokes -----
	"SCENE_LOADED" : {
		"subscribers" : [],
		"params" : []},
	"SCENE_UNLOADED" : {
		"subscribers" : [],
		"params" : []},
	"SCENE_CHANGE_REQUEST" : {
		"subscribers" : [],
		"params" : []},
	"SCENE_CHANGE_SUCCESS" : {
		"subscribers" : [],
		"params" : []},
	"SCENE_CHANGE_FAIL" : {
		"subscribers" : [],
		"params" : []},
	
	# ---- player special events ;; invert cutscene -----
	"SPECIAL_INVERT_CUTSCENE_BEGIN" : {
		"subscribers" : [],
		"params" : []},
	"SPECIAL_INVERT_CUTSCENE_END" : {
		"subscribers" : [],
		"params" : []},
	
	## WORLD.
	"WORLD_LOOP" : {
		"subscribers" : [],
		"params" : []},
	"WORLD_TIME_DAY" : {
		"subscribers" : [],
		"params" : []},
	"WORLD_TIME_NIGHT" : {
		"subscribers" : [],
		"params" : []},
}
