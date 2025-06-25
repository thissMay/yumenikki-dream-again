class_name PLEffect
extends Resource

@export_group("Information")
@export var name: String = ""
@export var desc: String = ""
@export var icon: Texture2D

var use_times: int = 0

@export_group("Attributes")
@export var stats: PlayerStats = preload("res://src/player/madotsuki/effects/_none/_stats.tres")
@export var behaviour: PLBehaviour = preload("res://src/player/madotsuki/effects/_none/_behaviour.tres")

@export var primary_action: PLAction = null
@export var secondary_action: PLAction = null

@export_group("Display")
@export_file("*.tres") var sprite_override: String = preload("res://src/player/madotsuki/sprite_sheets/no_effect.tres").resource_path
@export_file("*.tres") var emote: String = preload("res://src/player/madotsuki/emotes/sit_down.tres").resource_path

@export_file("*.tscn") var player_component_prefab: String
var player_component: Node

func _apply(_pl: Player) -> void:
	if primary_action: (_pl as Player_YN).components.get_component_by_name("action_manager").set_primary_action(primary_action)
	if secondary_action: (_pl as Player_YN).components.get_component_by_name("action_manager").set_secondary_action(primary_action)
	
	if !emote.is_empty() and load(emote): 
		(_pl as Player_YN).components.get_component_by_name("action_manager").set_emote(load(emote))
	if load(sprite_override): _pl.set_sprite_sheet(load(sprite_override))
	
	if stats: 
		stats._apply(_pl)
	if behaviour: 
		behaviour._enter(_pl)
		behaviour._apply(_pl)

func _unapply(_pl: Player) -> void:
	(_pl as Player_YN).components.get_component_by_name("action_manager").cancel_action(
		(_pl as Player_YN).components.get_component_by_name("action_manager").curr_action, _pl)
	
	(_pl as Player_YN).set_sprite_sheet(load(_pl.DEFAULT_EFFECT.sprite_override))
	
	(_pl as Player_YN).components.get_component_by_name("action_manager").set_primary_action(null)
	(_pl as Player_YN).components.get_component_by_name("action_manager").set_secondary_action(null)
	(_pl as Player_YN).components.get_component_by_name("action_manager").set_emote(null)
	
	if stats: stats._unapply(_pl)
	if behaviour: behaviour._exit(_pl)
	
	(_pl as Player_YN).revert_def_behaviour()

func _use(_pl: Player) -> void: 
	use_times += 1
	(_pl as Player_YN).perform_action(primary_action)

# ---- misc. getters.
func get_eff_name() -> String: return name
