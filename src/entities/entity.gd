class_name Entity
extends Node2D

enum compass_headings {
	NORTH = 0,
	NORTH_HORIZ = 1,
	
	HORIZ = 2,
	
	SOUTH_HORIZ = 3,
	SOUTH = 4}
var heading: compass_headings
var direction: Vector2 = Vector2(0, 1):
	set(dir): direction = clamp(dir, Vector2(-1, -1), Vector2(1, 1))
var height: float = 0

func _ready() -> void: pass

func set_active(_active: bool) -> void:
	self.set_process(_active)
	self.set_physics_process(_active)
	self.set_process_input(_active)	
func _handle_heading(_dir: Vector2 = direction) -> compass_headings:
		if abs(_dir.x) > 0: 
			if _dir.y > 0: heading = compass_headings.SOUTH_HORIZ
			elif _dir.y < 0: heading = compass_headings.NORTH_HORIZ
			else: heading = compass_headings.HORIZ
		else:
			if _dir.y > 0: heading = compass_headings.SOUTH
			elif _dir.y < 0: heading = compass_headings.NORTH
			
		return heading

# -------------------------------------------------------------------
# --------------------------SENTIENT ENTITY--------------------------
# -------------------------------------------------------------------

class SentientEntity:
	extends Entity
	
	var noise: float = 0
	
	var external_velocity: Vector2:
		get: return Vector2(floor(external_velocity.x), floor(external_velocity.y))
	var external_decelleration_thresh := Vector2.ZERO
	
	# ---- acelleration / friction
	var acceleration: float = 0
	var friction: float = 300
	
	# ---- push and move flags
	var push_strength := 1.0
	var is_moving: bool
	
	func _init() -> void:
		assert(is_instance_of(self, PhysicsBody2D), "Error: ObjectEntity must be a derivative of PhysicsBody2D!")
		assert(is_instance_of(self, SentientBase), "Error: SentientEntity must be a derivative of SentientBase!")
	func _process(delta: float) -> void:
		handle_decelleration()
		
		is_moving = (self as SentientBase).abs_velocity != Vector2.ZERO
		(self as SentientBase).move_and_slide()
		
		# --- apply forces on rigid bodies.
		#for i in range((self as SentientBase).get_slide_collision_count()):
			#var c = (self as SentientBase).get_slide_collision(i)
			#
			#if c.get_collider() is RigidBody2D: 
				#c.get_collider().apply_central_impulse(
					#-c.get_normal() * (push_strength / (c.get_collider().mass * 1.25)))
	
	func handle_ext_acceleration() -> void: pass 
	func handle_decelleration() -> void:
		external_velocity = external_velocity.move_toward(Vector2.ZERO, get_process_delta_time() * friction)
