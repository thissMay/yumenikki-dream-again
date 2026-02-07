@tool

class_name Player_YN 
extends Player


# - dependencies.
@export_category("Top-down Exclusive")
@export var can_pinch: bool = true

var audio_listener: AudioListener2D
var sound_player: AudioStreamPlayer


# - trait components
var global_components: SBComponentReceiver

var sprite_sheet: SerializableDict = preload("res://src/player/2D/madotsuki/display/no_effect.tres"):
	get:
		if values != null and \
		!values.sprite_override.is_empty() and\
		ResourceLoader.exists(values.sprite_override):
			return load(values.sprite_override)
		
		return sprite_sheet
		
	set(sheet):
		sprite_sheet = sheet
		set_texture_using_sprite_sheet(sprite_id)
		
var sprite_id: String = ""
var action: PLAction 

func _ready() -> void:
	super()
	if Engine.is_editor_hint(): return

	Utils.connect_to_signal(
		func(_in):
			vel_input = _in
			dir_input = _in, 	
		self.input_vector)
	
	Utils.connect_to_signal(get_behaviour()._interact, quered_interact)
func _enter() -> void:
	super()
	if GameManager.global_player_components != null: 
		global_components = GameManager.global_player_components
		global_components._setup(self)

func dependency_components() -> void:	
	audio_listener = $audio_listener
	sound_player = $sound_player
func dependency_setup() -> void:
	fsm.		_setup(self)			# --- fsm; 

func _update(_delta: float) -> void:	
	super(_delta)
	if fsm: fsm._update(_delta)
	if global_components != null: global_components._update(_delta)
func _physics_update(_delta: float) -> void:
	super(_delta)
	if fsm: fsm._physics_update(_delta)
	if global_components != null: global_components._physics_update(_delta)
func _sb_input(event: InputEvent) -> void:
	if Input.is_physical_key_pressed(KEY_Q) and can_pinch: 
		perform_action(PLActionManager.PINCH_PRESS_ACTION)
		
	if components != null: 	components._input_pass(event)
	if fsm != null: 		fsm._input_pass(event)
	
func perform_action(_action: PLAction) -> void:
	if components.bypass or !components.get_component_by_name(Components.ACTION).active: return
	components.get_component_by_name(Components.ACTION).perform_action(self, _action)
func cancel_action(_action: PLAction = action) -> void: 
	if components.bypass or !components.get_component_by_name(Components.ACTION).active: return
	components.get_component_by_name(Components.ACTION).cancel_action(self, _action)

func equip(_effect: PLEffect, _skip: bool = false) -> void: 
	if components.bypass or !components.get_component_by_name(Components.EQUIP).active: return
	components.get_component_by_name(Components.EQUIP).equip(self, _effect, _skip)
func deequip_effect() -> void: 
	if components.bypass or !components.get_component_by_name(Components.EQUIP).active: return
	components.get_component_by_name(Components.EQUIP).deequip(self)

func get_behaviour() -> PLBehaviour: 
	return components.get_component_by_name(Components.EQUIP).behaviour

func play_sound(_sound: AudioStreamWAV, _vol: float, _pitch: float) -> void:
	if sound_player != null: sound_player.play_sound(_sound, _vol, _pitch)
func set_texture_using_sprite_sheet(_sprite_id: String) -> void:
	sprite_id = _sprite_id
	if 	sprite_sheet.dict.has(_sprite_id):
		sprite_renderer.texture = (sprite_sheet.dict[_sprite_id])
func set_sprite_sheet(_new_sheet: SerializableDict) -> void:
	sprite_sheet = _new_sheet

# - misc.
func get_values() -> SBVariables:
	if  components != null and \
		components.has_component_by_name(Components.EQUIP) and \
		components.get_component_by_name(Components.EQUIP).effect_values != null:
			return components.get_component_by_name(Components.EQUIP).effect_values
	else:
		return super()

# -------------------------------------------------------------

class Components:
	const ANIMATION 	:= &"animation_manager"
	const ACTION 		:= &"action_manager"
	const SPRITE 		:= &"sprite_manager"
	const EQUIP 		:= &"equip_manager"
	const INTERACT 		:= &"interaction_manager"
	const MENTAL 		:= &"mental_status"
	const FOOTSTEP 		:= &"footstep_manager"
	const INPUT 		:= &"input"
