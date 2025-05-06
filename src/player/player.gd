class_name Player
extends SentientBase

@export_file("*.tscn") var access_menu: String

# ---- controllers. ----
var controller: SentientController

#region ---- data variables ----

@export var walk_multiplier: float = WALK_MULTI
@export var sneak_multiplier: float = SNEAK_MULTI
@export var sprint_multiplier: float = SPRINT_MULTI
@export var exhaust_multiplier: float = EXHAUST_MULTI

var stamina_drain: float = STAMINA_DRAIN
var stamina_regen: float = STAMINA_REGEN
var stamina: float = MAX_STAMINA:
	set(_stam):
		stamina = _stam
		GameManager.EventManager.invoke_event("PLAYER_STAMINA_CHANGE", [_stam])

var is_exhausted: bool = false
var can_run: bool = CAN_RUN

# ---- sanity & adrenaline ----
const MAX_ADRENA := 100

const MAX_SANITY := 100
const MIN_SANE_THRESHOLD := 35
const MIN_INSANE_THRESHOLD := 30

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
#endregion ---- data variables ----

# ---- initial ----
func _enter_tree() -> void: 
	PLInstance.player = self
	GameManager.EventManager.invoke_event("PLAYER_UPDATED")
func _ready() -> void:
	super()

# ---- process ----
func _process(_delta: float) -> void:
	super(_delta)
func _physics_process(_delta: float) -> void:
	super(_delta)
			
# ---- controller ----
func set_controller(_controller: SentientController) -> void: 
	controller = _controller
	_controller.sentient = self

# ---- sanity and adrenaline ----
func set_adrenaline(_ad: float) -> void: 
	PLInstance.adrenaline = clamp(_ad, 0 , MAX_ADRENA)
	GameManager.EventManager.invoke_event("PLAYER_ADRENALINE_CHANGE", [_ad])
func set_sanity(_sn: float) -> void: 
	PLInstance.sanity = clamp(_sn, 0, MAX_SANITY)
	GameManager.EventManager.invoke_event("PLAYER_SANITY_CHANGE", [_sn])
	if get_sanity() > MIN_SANE_THRESHOLD: GameManager.EventManager.invoke_event("PLAYER_SANITY_SANE_STATE")
	elif get_sanity() < MIN_INSANE_THRESHOLD: GameManager.EventManager.invoke_event("PLAYER_SANITY_INSANE_STATE")

func change_adrenaline(_ad: float) -> void:
	set_adrenaline(_ad + get_adrenaline())
func change_sanity(_sn: float) -> void:
	set_sanity(_sn + get_sanity())

func get_adrenaline() -> float: return PLInstance.adrenaline
func get_sanity() -> float: return PLInstance.sanity
