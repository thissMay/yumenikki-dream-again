# ---- 	!!IMPORTANT !! 	----
# - ensure that any object that uses this class is a... -
# - ... derivative of CharacterBody2D ... 				-
# ----					----

class_name SentientBase
extends Entity.SentientEntity

var world_warp: Area2D
var components: SBComponentReceiver
const TRANS_WEIGHT := 0.225

const BASE_SPEED: float = 27.5
const SPRINT_MULT: float = 2.3
const MAX_SPEED: float = 35

@export_category("Base Entity Behaviour")

var sprite_renderer: Sprite2D
var shadow_renderer: Sprite2D # -- optional
var desired_vel: Vector2

@export_subgroup("Direction Vectors")
var lerped_direction: Vector2 = Vector2.DOWN

#region ---- mobility and velocity properties ----
@export_group("Mobility Values")

var speed: float = 0
var speed_multiplier: float = 1
@export var initial_speed: float = BASE_SPEED

var abs_velocity: Vector2:
	get: return abs(self.velocity)
var normalized_vel: Vector2:
	get: return self.velocity.normalized()

@export_group("Auditorial")
var noise_multi: float = 1
#endregion

func _ready() -> void:
	sprite_renderer = get_node_or_null("sprite_renderer")
	shadow_renderer = get_node_or_null("shadow_renderer")
	
	world_warp = get_node_or_null("world_warp")
	components = $sb_components
	components._setup(self)
		
	await self.ready
	self.motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	
	dependency_components()
	dependency_setup()
	
func dependency_components() -> void: pass 	
func dependency_setup() -> void: pass 

# ---- base processes ----
func _physics_process(_delta: float) -> void:
	components._physics_update(_delta)
	speed = self.velocity.length()
	abs_velocity = abs(self.velocity)
	
func _process(_delta: float) -> void:
	(self as SentientBase).move_and_slide()
	super(_delta) # --- sentient entity override.
	
	_handle_heading(direction)
	components._update(_delta)

#region ---- velocity and acceleration handling ----
func handle_velocity(_dir: Vector2, _mult: float = 1) -> void:
	desired_vel = ((_dir.normalized() * initial_speed) * _mult) + external_velocity
	self.velocity = desired_vel
	
#endregion
#region ---- direction ----

func get_dir() -> Vector2: 
	return self.direction
func get_lerped_dir() -> Vector2: 
	return self.lerped_direction

func lerp_dir(_dir: Vector2, interpolation_multi: float = 1) -> void:
	if _dir != Vector2.ZERO: 
		lerped_direction = lerped_direction.lerp(_dir, interpolation_multi)
func look_at_dir(_dir: Vector2) -> void: 
	if _dir != Vector2.ZERO: 
		direction = _dir
		lerp_dir(_dir, TRANS_WEIGHT)
#endregion

func handle_noise() -> void:
	noise = (self.speed / self.MAX_SPEED) * noise_multi
func get_noise() -> float: 
	return noise
