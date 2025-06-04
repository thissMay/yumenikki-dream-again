class_name Player
extends SentientBase

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

const NOISE_MULTI: float = 1

var walk_noise_mult: float = 1
var run_noise_mult: float = 2.2
var sneak_noise_mult: float = 0.1
#endregion ---- data variables ----

# ---- initial ----
func _enter_tree() -> void: 
	PLInstance.player = self
	GameManager.EventManager.invoke_event("PLAYER_UPDATED")
