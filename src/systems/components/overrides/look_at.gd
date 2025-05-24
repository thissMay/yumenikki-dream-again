@icon("res://src/images/editor/components/comp_look-at.png")

class_name LookAt extends Component

var origin_pos: Vector2 # readonly
var angle_rads: float 	# readonly
@export var r: float = 1 # radius
@export var look_at_target: Node2D

var target_vector: Vector2

func setup():
	super()
	origin_pos = receiver.affector.position

func _physics_update(_delta: float) -> void:
	if receiver != null && look_at_target != null:
		angle_rads = atan2(distance_to(look_at_target).y, distance_to(look_at_target).x)
		receiver.affector.position.x = clamp(receiver.affector.position.x, r, r * cos(angle_rads)) + origin_pos.x
		receiver.affector.position.y = clamp(receiver.affector.position.y, r, r * sin(angle_rads)) + origin_pos.y

func distance_to(distance_target: Node2D) -> Vector2:
	if receiver and receiver.affector: return distance_target.global_position - receiver.affector.global_position
	return Vector2()
