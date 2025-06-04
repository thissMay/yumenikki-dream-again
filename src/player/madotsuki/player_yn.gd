class_name Player_YN extends Player

# ----> dependencies
var audio_listener: AudioListener2D
var sound_player: AudioStreamPlayer

var animation_manager: SentientAnimator
var footstep_manager: Node

 	
const DEFAULT_DISPLAY := preload("res://src/player/madotsuki/sprite_sheets/no_effect.tres") as SerializableDict
var DEFAULT_BEHAVIOUR := PlayerBehaviour.new()
var DEFAULT_STATS := PlayerStats.new()

var stats_data := DEFAULT_STATS
var behaviour := DEFAULT_BEHAVIOUR

# ----> trait components
var world_warp: Area2D

var marker_look_at: Strategist
var stamina_fsm: FSM

var mental_status: SBComponent

@onready var emote: PlayerEmote = PLInstance.def_emote
@export var effect: PlayerEffect
@export var sprite_sheet: SerializableDict

var action: PlayerAction 


func dependency_components() -> void:	
	marker_look_at._setup()			# --- fsm; not player dependency but required
	stamina_fsm._setup() 	# --- fsm; not player dependency but required
	fsm._setup(self)			# --- fsm; not player dependency but required
	
	if components.get_component_by_name("health"):
		components.get_component_by_name("health").took_damage.connect( 
			func(_dmg: float):
				GameManager.EventManager.invoke_event("PLAYER_HURT", [_dmg]))
func mandatory_components() -> void:
	animation_manager = components.get_component_by_name("animation_manager")
	
	audio_listener = $audio_listener
	sound_player = $sound_player
	
	world_warp = $world_warp	
	marker_look_at = $look_at
	
	fsm = $fsm
	stamina_fsm = $fsm/stamina_fsm
	
# ---- direction handling ----
func get_marker_direction() -> Vector2: return marker_look_at.position
func set_marker_direction_mode(_new_mode: Strategy) -> void: 
	assert(_new_mode is Strategy)
	marker_look_at._change_strat(_new_mode)
#region PROCESS and INPUT
# ---- process / input ----
func _process(_delta: float) -> void:	
	super(_delta)
	handle_noise()
	if fsm: fsm._update(_delta)
func _physics_process(_delta: float) -> void:
	super(_delta)
	stamina_fsm._physics_update(_delta)
	if behaviour: behaviour._physics_update(self, _delta)
	if fsm: fsm._physics_update(_delta)

func _unhandled_input(event: InputEvent) -> void:
	dependency_input(event)
			
	if event is InputEventKey && Global.input:
		if fsm: fsm._input_pass(event)
	
		if (Global.input["key_pressed"] == KEY_SPACE and
			Global.input["held_down"]):
				perform_action(components.get_component_by_name("action_manager").action)
		
		if (Global.input["key_pressed"] == KEY_E &&
			Global.input["pressed_once"]) and components.get_component_by_name("interaction_manager"): 
				get_behaviour()._interact(self, components.get_component_by_name("interaction_manager").curr_interactable)

func dependency_input(event: InputEvent) -> void:
	if event is InputEventKey && Global.input:
		if components: 
			components._input_pass(event)
			if components.get_component_by_name("equip_manager"):
				components.get_component_by_name("equip_manager")._input_effect(event, self)

#endregion

#region EMOTES, UNIQUE, BEHAVIOUR
# ---- unique ----
func perform_emote(_emote: PlayerEmote) -> void:
	perform_action(_emote)
#func cancel_emote() -> void: 
	#action_manager.cancel_emote(emote, self)

func perform_action(_action: PlayerAction) -> void: 
	components.get_component_by_name("action_manager").perform_action(_action, self)
func cancel_action(_action: PlayerAction = action) -> void: 
	components.get_component_by_name("action_manager").cancel_action(_action, self)

func get_effect() -> PlayerEffect: return effect
func equip(_effect: PlayerEffect, _skip_anim: bool = false) -> void: 
	components.get_component_by_name("equip_manager").equip(_effect, self, _skip_anim)
	PLInstance.equipment_pending = _effect

func deequip_effect(_skip_anim: bool = false) -> void: 
	components.get_component_by_name("equip_manager").deequip(effect, self, _skip_anim)
	set_sprite_sheet(DEFAULT_DISPLAY)

func set_behaviour(_beh: PlayerBehaviour) -> void:
	behaviour = _beh
func revert_def_behaviour() -> void: behaviour = DEFAULT_BEHAVIOUR
func get_behaviour() -> PlayerBehaviour: return behaviour
#endregion

#region STATES and ANIMATIONS
func force_change_state(_new: String) -> void: fsm._change_to_state(_new)
func get_state_name() -> String: return fsm._get_curr_state_name()

func play_sound(_sound: AudioStreamWAV, _vol: float, _pitch: float) -> void:
	if sound_player != null: (sound_player as SoundPlayer).play_sound(_sound, _vol, _pitch)
func set_texture_using_sprite_sheet(_sprite_id: String) -> void:
	sprite_renderer.texture = (
			(sprite_sheet.dict[_sprite_id] if 
			sprite_sheet.dict.has(_sprite_id) else 
			preload("res://src/images/missing.png"))
		)
func set_sprite_sheet(_new_sheet: SerializableDict) -> void:
	sprite_sheet = _new_sheet
	set_texture_using_sprite_sheet(get_state_name())
#endregion
