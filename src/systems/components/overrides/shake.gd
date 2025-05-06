
## This class needs a plugin to make sure previewing is easier and flexible.
## not really lol.

class_name Shake extends Component

var time_elapsed: float
var destroy_after_finish: bool = true

@export_group("Rotational Wiggle")
var origin_rot: float
var got_origin_rot: bool = false

@export var shake_rot_strength: float = 1
@export var shake_rot_speed: float = 1

@export_group("Position Wiggle")
var got_origin_pos: bool = false
var initial_x: float
var initial_y: float

@export var shake_strength: float = 1
@export var shake_speed: float = 1
@export var shake_duration: float = 1

@export_group("Flags")
@export var decay: bool = false
@export var ignore_rotation: bool = true


func _init(
		_magnitude: float = 1, 
		_speed: float = 1, 
		_dur: float = 1,
		_destroy: bool = true) -> void:
	setup()
	
	shake_strength = _magnitude
	shake_speed = _speed
	shake_duration = _dur
	
	destroy_after_finish = _destroy
func setup() -> void: 
	self.name = "shake"
	receiver = get_parent()

func get_origin_pos() -> void:
	initial_x = receiver.position.x
	initial_y = receiver.position.y
	got_origin_pos = true
func get_origin_rot() -> void:
	origin_rot = receiver.rotation
	initial_y = receiver.position.y
	got_origin_rot = true

func _physics_update(_delta: float) -> void:	
	time_elapsed += _delta
	var decay := time_elapsed * int(decay)
	
	var eqn_x = 0.12 * shake_strength * pow(20.11, -(time_elapsed - shake_duration)) * sin(shake_speed * 50 * time_elapsed) + initial_x
	var eqn_y = 0.12 * shake_strength * pow(20.11, -(time_elapsed - shake_duration)) * cos((shake_speed * 50 / .987) * (time_elapsed)) + initial_y

	receiver.position.x = eqn_x
	receiver.position.y = eqn_y
	receiver.rotation_degrees = 0.05 * pow(20.87, -(time_elapsed - shake_duration)) * sin(shake_speed * 60 * time_elapsed)

	if shake_duration - (time_elapsed * int(decay)) <= 0: 
		receiver.position = Vector2()
		receiver.rotation_degrees = 0
		if destroy_after_finish: self.queue_free()
		else: set_active(false)
func reset(
		_magnitude: float = shake_strength, 
		_speed: float = shake_speed, 
		_dur: float = shake_duration
		) -> void: 
			time_elapsed = 0
			shake_strength = _magnitude
			shake_speed = _speed
			shake_duration = _dur
			
			set_active(true)
					
