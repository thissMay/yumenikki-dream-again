class_name PlayerEffect
extends Resource


@export_group("Information")
@export var name: String = ""

var use_times: int = 0

@export_group("Attributes")
@export var stats: PlayerStats = null
@export var behaviour: PlayerBehaviour = null
@export var action: PlayerAction = null
@export var sprite_override: SerializableDict

@export_group("Attributes Flag")
@export var stats_override: bool = false
@export var behaviour_override: bool = false
@export var action_override: bool = false

@export_file("*.tscn") var player_component_prefab: String
var player_component: Node

func _enter(_pl: Player) -> void: 
	if behaviour: behaviour._enter(_pl)
func _exit(_pl: Player) -> void: 
	if behaviour: behaviour._exit(_pl)

func _apply(_pl: Player) -> void:
	if sprite_override: _pl.set_sprite_sheet(sprite_override)
	if stats: stats._apply(_pl)
	if behaviour: behaviour._apply(_pl)
	if action: (_pl as Player_YN).action_manager.set_action(action)
func _unapply(_pl: Player) -> void:
	if stats: stats._unapply(_pl)
	if behaviour: behaviour._unapply(_pl)
	if action: (_pl as Player_YN).action_manager.set_action(null)

func _use(_pl: Player) -> void: 
	use_times += 1
	if action: (_pl as Player_YN).perform_action(action)

# ---- misc. getters.
func get_eff_name() -> String: return name
