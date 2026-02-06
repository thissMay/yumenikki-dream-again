@tool

class_name CameraHolder
extends Node2D

static var instance: CameraHolder

var old_pos:	 Vector2
var new_pos: 	Vector2
var vel: 		Vector2

@export var fsm: FSM

# ---- FOLLOW STRATS ----
@export_group("Miscallenous")
@export var follow_speed: float = 2.35
static var default 			:= STRAT_FOLLOW.new()
static var follow_player 	:= STRAT_FOLLOW_SENTIENT.new()
static var follow_lerp 		:= STRAT_FOLLOW_DEFAULT.new()

var prev_follow_strat: STRAT_FOLLOW = default
var curr_follow_strat: STRAT_FOLLOW = default

# ---- components
@export var cam: Camera2D
@export var marker: Marker2D
@export var cam_receiver: ComponentReceiver
@export var components: ComponentReceiver

var shake_comp: CamShake

# ---- cam properties
@export_group("Camera Properties")
@export var offset: Vector2 = Vector2(0, 0): set = set_offset
@export_range(0.8, 2) var zoom: float = 1: set = set_zoom
var switch_duration: float = .35

@export var override: bool = false:
	set(ov):
		override = ov 
		set_override_flag(ov)

@export_subgroup("Rotation TIlt")
@export var rot_curve: 		Curve = preload("res://src/systems/camera/rotational_wiggle_curve.tres")
@export var rot_strength: 	float = .7
@export var rot_speed: 		float = 8.5

static var motion_reduction: bool = false:
	set(_reduction):
		motion_reduction = _reduction
		if CameraHolder.instance:
			if _reduction: 
				CameraHolder.instance.set_follow_strategy(default)
				CameraHolder.instance.cam_receiver.bypass = true
				CameraHolder.instance.components.bypass = true
				
			else: 
				CameraHolder.instance.set_follow_strategy(follow_player)
				CameraHolder.instance.cam_receiver.bypass = false
				CameraHolder.instance.components.bypass = false

var offset_tween: Tween
var zoom_tween: Tween

# ---- target
@export_group("Target Properties")
@export var initial_target: CanvasItem:
	set(_target):
		initial_target = _target
		if _target != null and Engine.is_editor_hint():
			Utils.connect_to_signal(func(): 
				if !initial_target.is_inside_tree(): initial_target = null, initial_target.tree_exiting)
var curr_target: CanvasItem
var prev_target: CanvasItem

func _ready() -> void:
	instance = self
	self.top_level = true
	self.process_mode = Node.PROCESS_MODE_PAUSABLE
	
	motion_reduction = motion_reduction
	
	if Engine.is_editor_hint(): 
		if initial_target != null:
			global_position = initial_target.global_position
	else:
		fsm._setup(self)
		set_target(initial_target)
		
		cam.editor_draw_screen = true
		cam.editor_draw_limits = true
		
		if !initial_target: initial_target = self ## ensures that its going to be static at least.
		await Game.main_tree.process_frame
		
		assert(initial_target is CanvasItem)
		if shake_comp == null: shake_comp = CamShake.new(self.cam)
		shake_comp.cam = self.cam
	
func _process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	fsm._update(_delta)
	set_zoom(zoom)
	set_offset(offset)
	if shake_comp: shake_comp._handle(_delta)
	

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint(): return
	
	old_pos = new_pos
	new_pos = self.global_position
	vel = new_pos - old_pos
	
	fsm._physics_update(_delta)
	
# ---- follow strats  ----
func set_follow_strategy(strat: STRAT_FOLLOW):
	prev_follow_strat = curr_follow_strat
	curr_follow_strat = strat
	curr_follow_strat._changed()

# ---- cam control ----
func set_zoom(_zoom: float) -> void:
	zoom = _zoom
	cam.zoom = Vector2(_zoom, _zoom)
func set_cam_limit(_up: int, _down: int, _right: int, _left: int) -> void: 
	cam.limit_top = _up
	cam.limit_bottom = _down
	cam.limit_right = _right
	cam.limit_left = _left

func set_offset(_offset: Vector2) -> void: 
	offset = _offset
	marker.position = _offset
func set_target(_target: CanvasItem, _dur: float = .5) -> void:
	if _target == null: return
	
	switch_duration = _dur
	curr_target 	= _target
	fsm.change_to_state("changing_target")
	
	if (_target as Node) is SentientBase: 
			set_follow_strategy(follow_player if !motion_reduction else default)
	else: 	set_follow_strategy(follow_lerp if !motion_reduction else default)
	
	curr_follow_strat._setup(self)
	
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
	await offset_tween.finished
func lerp_zoom(_zoom: float, _ease: Tween.EaseType, _trans: Tween.TransitionType,  _dur: int) -> void:
	if zoom_tween: zoom_tween.kill()
	zoom_tween = marker.create_tween()
	
	zoom_tween.set_ease(_ease)
	zoom_tween.set_trans(_trans)
	
	zoom_tween.tween_method(set_zoom, zoom, _zoom, _dur)
	await zoom_tween.finished

# ---- shake ----
func shake(_magnitude: float, _speed: float, _dur: float) -> void: 
		shake_comp.magnitude = _magnitude
		shake_comp.speed = _speed
		shake_comp.duration = _dur
		
		shake_comp.request()
		shake_comp.ignore_rotation = false

class CamShake:
	extends RefCounted
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

# -- strats
class STRAT_FOLLOW:
	extends Strategy

	var final: Vector2

	func _setup(_cam: CameraHolder) -> void: pass
	func _follow(_cam: CameraHolder, _point: Vector2) -> void: 
		_cam.global_position = _point

	func _changed() -> void: pass

class STRAT_FOLLOW_DEFAULT:
	extends STRAT_FOLLOW
	func _follow(_cam: CameraHolder, _point: Vector2) -> void:
		final = _cam.global_position.lerp(_point, Game.get_real_delta() * _cam.follow_speed)
		_cam.global_position = final
class STRAT_FOLLOW_SENTIENT:
	extends STRAT_FOLLOW
	
	var player: Player
	var calculated: Vector2

	var look_ahead_distance: float = 30
	var look_ahead: Vector2
	var MAX_LOOK_AHEAD_PIXELS := Vector2(15, 5)

	func _setup(_cam: CameraHolder) -> void:
		player = Player.Instance.get_pl()
		
	func _follow(_cam: CameraHolder, point: Vector2) -> void:
		if player == null:  return
		look_ahead = look_ahead.lerp(
			(player.velocity * look_ahead_distance).clamp(-MAX_LOOK_AHEAD_PIXELS, MAX_LOOK_AHEAD_PIXELS), 
			Game.get_real_delta() * _cam.follow_speed)
		final = point + look_ahead

		_cam.global_position = final
	func _changed() -> void: look_ahead = Vector2.ZERO
