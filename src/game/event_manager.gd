class_name EventManager

const SUBSCRIBES_STR 	:= "subscribers"
const PARAMS_STR 		:= "params"

static func _setup() -> void:
	for i in event_ids: create_event(i)

static func add_listener(_listener: EventListener, _id: String) -> void:
	create_event(_id)
	event_ids[_id][SUBSCRIBES_STR].append(_listener)
static func remove_listener(_listener: EventListener, _id: String) -> void:
	if  event_ids[_id][SUBSCRIBES_STR].find(_listener) != -1:
		event_ids[_id][SUBSCRIBES_STR].remove_at(
			event_ids[_id][SUBSCRIBES_STR].find(_listener)
			)
static func create_event(_id: String) -> void:
	if !event_ids.has(_id):					event_ids[_id] = {}
	if !event_ids[_id].has(SUBSCRIBES_STR): event_ids[_id][SUBSCRIBES_STR] = []
	if !event_ids[_id].has(PARAMS_STR): 	event_ids[_id][PARAMS_STR] = []
		
static func invoke_event(_id: String, ..._params: Array) -> void: 
	_id = _id.to_upper()
	create_event(_id)
	event_ids[_id][PARAMS_STR] = _params
	
	for i in range((event_ids[_id][SUBSCRIBES_STR] as Array[EventListener]).size()):
		if 	event_ids[_id][SUBSCRIBES_STR][i].is_valid_listener: 
			event_ids[_id][SUBSCRIBES_STR][i].on_notify(_id)
		else: 
			remove_listener(event_ids[_id][SUBSCRIBES_STR][i], _id)
static func get_event_param(_id: String) -> Array:
	if 		(event_ids[_id][PARAMS_STR] as Array).is_empty(): return [null]
	return 	 event_ids[_id][PARAMS_STR]

static var event_ids := {
		# ---- game events -----
		"STATE_PREGAME" : {},
		"STATE_PAUSE" : {},
		"STATE_ACTIVE" : {},
		
		"GAME_FILE_SAVE" : {},
		"GAME_CONFIG_SAVE" : {},
		
		"GAME_PRELOADING_CONTENT_FINISH" : {},
		"GAME_PRELOADING_CONTENT_START" : {},
		
		# ---- reality states -----
		"REALITY_DREAM" : {},
		"REALITY_NEUTRAL" : {},
		
		# ---- cutscenes -----
		"CUTSCENE_START" : {},
		"CUTSCENE_END" : {},
		"CUTSCENE_START_REQUEST" : {},
		"CUTSCENE_END_REQUEST" : {},
		
		# ---- player ----
		"PLAYER_UPDATED" : {},
		
		"PLAYER_MOVE" : {},
		"PLAYER_ACTION" : {},
		"PLAYER_EMOTE" : {},
		"PLAYER_INTERACT" : {},
		"PLAYER_HURT" : {},
		"PLAYER_WAKE_UP" : {},
		
		"PLAYER_EQUIP" : {},
		"PLAYER_DEEQUIP" : {},

		"PLAYER_EFFECT_FOUND" : {},
		"PLAYER_EFFECT_DISCARD" : {},
			
		"PLAYER_DOOR_TELEPORTATION" : {},
			
		"PLAYER_DOOR_USED" : {},
		"PLAYER_SANITY_CHANGE" : {},
		"PLAYER_ADRENALINE_CHANGE" : {},	

		# ---- chase events -----
		"PRECHASE_ACTIVE" : {},
		"PRECHASE_FINISH" : {},
		"CHASE_ACTIVE" : {},
		"CHASE_FINISH" : {},

		# ---- scene change invokes -----
		"SCENE_LOADED" : {},
		"SCENE_UNLOADED" : {},
		"SCENE_CHANGE_REQUEST" : {},
		"SCENE_CHANGE_SUCCESS" : {},
		"SCENE_CHANGE_FAIL" : {},
		
		# ---- player special events ;; invert cutscene -----
		"SPECIAL_INVERT_START_REQUEST" : {},
		"SPECIAL_INVERT_END_REQUEST" : {},
		"SPECIAL_INVERT_CUTSCENE_BEGIN" : {},
		"SPECIAL_INVERT_CUTSCENE_END" : {},
		
		## WORLD.
		"WORLD_LOOP" : {},
		"WORLD_TIME_DAY" : {},
		"WORLD_TIME_NIGHT" : {},
	}
