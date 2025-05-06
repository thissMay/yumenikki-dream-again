class_name CameraHolder
extends Node2D

static var cam: Camera2D
static var instance: CameraHolder

var old_pos: Vector2
var new_pos: Vector2
var vel: Vector2

var new_vel: Vector2
var old_vel: Vector2
var accel: Vector2

# ---- FOLLOW STRATS ----
@export_group("Miscallenous")
static var default := CameraFollowStrategy.new()
static var follow_player := FollowStrategyPlayer.new()
static var follow_lerp := FollowStrategyLerp.new()

var prev_follow_strat: CameraFollowStrategy = default
var curr_follow_strat: CameraFollowStrategy = default

# ---- components
var marker: Marker2D
var receiver: ComponentReceiver
static var shake_comp: CamShake

# ---- cam properties
@export_group("Camera Properties")

@export var bounds_min: Vector2 = Vector2(-100000, -100000)
@export var bounds_max: Vector2 = Vector2(100000, 100000)
@export var offset: Vector2 = Vector2(0, 0)
@export_range(0.8, 1.2) var zoom: float = 1

@export var override: bool = false:
	set(ov):
		override = ov 
		set_override_flag(ov)
static var motion_reduction: bool = false:
	set(_reduction):
		motion_reduction = _reduction
		if CameraHolder.instance:
			if _reduction: 
				CameraHolder.instance.set_follow_strategy(default)
				CameraHolder.instance.receiver.bypass = true
			else: 
				CameraHolder.instance.set_follow_strategy(CameraHolder.instance.prev_follow_strat)
				CameraHolder.instance.receiver.bypass = false

var offset_tween: Tween
var zoom_tween: Tween
var rot_curve: Curve = preload("res://src/systems/camera/rotational_wiggle_curve.tres")
var rot_strength: float = 1.4

# ---- target
@export_group("Target Properties")
@export var target: Node
var curr_target: Node
var prev_target: Node

var switching_to_target: bool = false
var switching_duration: float = 0.325
var switching_time_elapsed: float = 0

func _init() -> void: 
	self.name = "camera_handler"
	self.top_level = true
func _ready() -> void:
	set_follow_strategy(default)
	
	instance = self
	self.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	marker = $marker
	cam = $marker/camera
	receiver = $marker/camera/components_receiver
	
	motion_reduction = motion_reduction
	
	set_zoom(zoom)
	set_offset(offset)
	set_target(target)
	switching_to_target = false
	
	if !Engine.is_editor_hint():
		cam.editor_draw_screen = true
		cam.editor_draw_limits = true
		
		bounds_min = Vector2(cam.limit_left, cam.limit_top)
		bounds_max = Vector2(cam.limit_right, cam.limit_bottom)
		
		if !target: target = self ## ensures that its going to be static at least.
		await Global.get_tree().process_frame
		
		assert(target is Node2D || target is Control)
		global_position = target.global_position
		if shake_comp == null: shake_comp = CamShake.new(self.cam)
		shake_comp.cam = self.cam
	
	
func _process(delta: float) -> void:
	set_zoom(zoom)
	set_offset(offset)
	if shake_comp: shake_comp._handle(delta)
	self.position = self.position.clamp(bounds_min, bounds_max)
	


func _physics_process(_delta: float) -> void:
	old_pos = new_pos
	new_pos = self.global_position
	
	old_vel = new_vel
	new_vel = new_pos - old_pos
	
	vel = new_vel
	accel = new_vel - old_vel
	
	if !motion_reduction:
		if rot_curve:
			marker.global_rotation_degrees = lerpf(marker.global_rotation_degrees, rot_strength * rot_curve.sample(get_velocity().x), _delta * Global.TWEEN_SCALE)
	else:
			marker.global_rotation_degrees = 0
		
	
	if !Engine.is_editor_hint():
		if switching_to_target: 
			switching_time_elapsed += _delta
			self.global_position = self.global_position.lerp(target.global_position, 0.2)
	
			if switching_time_elapsed > switching_duration:
				switching_to_target = false
				switching_time_elapsed = 0
		
		elif curr_follow_strat: 
			curr_follow_strat._follow(self, self.global_position, target.global_position)

# ========== getters. ==========
func get_velocity() -> Vector2: return vel
func get_acceleration() -> Vector2: return accel

# ========== setters. ==========
# ---- follow strats  ----
func set_follow_strategy(strat: CameraFollowStrategy):
	prev_follow_strat = curr_follow_strat
	curr_follow_strat = strat
	curr_follow_strat._changed()
	curr_follow_strat._setup(self)

# ---- cam control ----
func set_zoom(_zoom: float) -> void:
	zoom = _zoom
	cam.zoom = Vector2(_zoom, _zoom)
func set_cam_limit(_up: float, _down: float, _right: float, _left: float) -> void: 
	cam.limit_top = _up
	cam.limit_bottom = _down
	cam.limit_right = _right
	cam.limit_left = _left

func set_offset(_offset: Vector2) -> void: 
	offset = _offset
	marker.position = _offset
func set_target(_target: Node) -> void:
	switching_time_elapsed = 0
	switching_to_target = true
	
	if _target:
		target = _target
		if target is Node2D: set_follow_strategy(follow_lerp if !motion_reduction else default)
		if target is SentientBase: set_follow_strategy(follow_player if !motion_reduction else default)
		
		if curr_target: prev_target = curr_target
		curr_target = _target
		
func set_override_flag(_override: bool) -> void:
	cam.top_level = _override
	match _override:
		true: cam.position = self.global_position
		_: cam.position = Vector2.ZERO
# ---- cam control (lerped, redundant) ----
func lerp_offset(_offset: Vector2, _ease: Tween.EaseType, _trans: Tween.TransitionType,  _dur: int) -> void:
	if offset_tween: offset_tween.kill()
	offset_tween = marker.create_tween()
	
	offset_tween.set_ease(_ease)
	offset_tween.set_trans(_trans)
	
	offset_tween.tween_method(set_offset, offset, _offset, _dur)
func lerp_zoom(_zoom: float, _ease: Tween.EaseType, _trans: Tween.TransitionType,  _dur: int) -> void:
	if zoom_tween: zoom_tween.kill()
	zoom_tween = marker.create_tween()
	
	zoom_tween.set_ease(_ease)
	zoom_tween.set_trans(_trans)
	
	zoom_tween.tween_method(set_zoom, zoom, _zoom, _dur)

# ---- shake ----
func shake(_magnitude: float, _speed: float, _dur: float) -> void: 
		shake_comp.magnitude = _magnitude
		shake_comp.speed = _speed
		shake_comp.duration = _dur
		
		shake_comp.request()
		shake_comp.ignore_rotation = false

class CamShake:
	extends Object
	var time_elapsed: float

	var origin_rot: float
	var got_origin_rot: bool = false

	var shake_rot_strength: float = 1
	var shake_rot_speed: float = 1

	var got_origin_pos: bool = false
	var initial_x: float
	var initial_y: float

	var magnitude: float = 1
	var speed: float = 1
	var duration: float = 1
	var decay: float = 1

	var is_decay: bool = true
	var is_shaking: bool = false
	var ignore_rotation: bool = true

	var cam: Camera2D

	func _init(
			_cam: Camera2D,
			_magnitude: float = 1, 
			_speed: float = 1, 
			_dur: float = 1) -> void:
		cam = _cam		
		magnitude = _magnitude
		speed = _speed
		duration = _dur
		
	func get_origin_pos() -> void:
		initial_x = cam.offset.x
		initial_y = cam.offset.y
		got_origin_pos = true
	func get_origin_rot() -> void:
		origin_rot = cam.rotation
		got_origin_rot = true

	func _handle(_delta: float) -> void:
		if is_shaking:	
			time_elapsed += _delta
			decay = time_elapsed * int(is_decay)
			
			var eqn_x = 0.12 * magnitude * pow(20.11, -(decay - duration)) * sin(speed * 50 * time_elapsed) + initial_x
			var eqn_y = 0.12 * magnitude * pow(20.11, -(decay - duration)) * cos((speed * 50 / .987) * (time_elapsed)) + initial_y

			cam.offset.x = eqn_x
			cam.offset.y = eqn_y
			cam.rotation_degrees = 0.05 * pow(20.87, -(decay - duration)) * sin(speed * 60 * time_elapsed)
						
			if duration - (decay) <= 0: 
				cam.offset = Vector2()
				cam.rotation_degrees = 0
				is_shaking = false
	func request() -> void: 
		time_elapsed = 0
		is_shaking = true
