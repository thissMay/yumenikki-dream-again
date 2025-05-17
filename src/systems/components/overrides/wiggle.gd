
## This class needs a plugin to make sure previewing is easier and flexible.
## not really lol.

class_name Wiggle extends Component

var timeelapsed: float


@export_group("Rotational Wiggle")
var origin_rot: float
var got_origin_rot: bool = false

@export var wig_rot_strn: float = 1
@export var wig_rot_speed: float = 1

@export_group("Position Wiggle")
var got_origin_pos: bool = false
var pos_init_x: float
var pos_init_y: float

@export var wig_x_strn: float = 1
@export var wig_y_strn: float = 1
@export var wig_pos_speed: float = 1

@export_group("Flags")
@export var ignore_rotation: bool = true
@export var execute_visual: bool = false:
	set(execute): 
		execute_visual = execute
		if receiver:
			if execute:
				pos_init_x = receiver.affector.position.x
				pos_init_y = receiver.affector.position.y
			else:
				if got_origin_pos: receiver.affector.position = Vector2(pos_init_x, pos_init_y)
				if got_origin_rot: receiver.affector.rotation_degrees = origin_rot

func _on_bypass_enabled() -> void: 
	timeelapsed = 0
	receiver.affector.position = get_origin_pos()
	receiver.affector.rotation_degrees = get_origin_rot()
	
func setup() -> void:
	#if !Engine.is_editor_hint(): execute_visual = true
	super()

	pos_init_x = receiver.affector.position.x
	pos_init_y = receiver.affector.position.y
	origin_rot = receiver.affector.rotation_degrees
	
	if Engine.is_editor_hint(): ## MAKE sure execute_visual is false on scene load for the mean-time
		execute_visual = false
		get_origin_pos()

func get_origin_pos() -> Vector2: return Vector2(pos_init_x, pos_init_y)
func get_origin_rot() -> float: return origin_rot

func update_initial_position(_new: Vector2) -> void:
	pos_init_x = _new.x
	pos_init_y = _new.y

func _physics_update(_delta: float) -> void:
	if execute_visual || !Engine.is_editor_hint():
		timeelapsed += _delta
		
		receiver.affector.position.x = lerp(
			pos_init_x, 
			wig_x_strn * cos(timeelapsed * wig_pos_speed) + pos_init_x, 
			_delta * wig_x_strn)
		receiver.affector.position.y = lerp(
			pos_init_y, 
			wig_y_strn * sin(1.25 * timeelapsed * wig_pos_speed) + pos_init_y, 
			_delta * wig_y_strn)

		if !ignore_rotation:
			receiver.affector.rotation_degrees = lerp(receiver.affector.rotation_degrees, sin(timeelapsed * wig_rot_speed) * wig_rot_strn, _delta)

func set_active(active: bool = true) -> void: 
	if active == false: 
		timeelapsed = 0
		receiver.affector.position = get_origin_pos()
		receiver.affector.rotation_degrees = get_origin_rot()
	super(active)
