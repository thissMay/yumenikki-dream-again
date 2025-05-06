class_name Rotation3DComponent
extends Component

@export var rotation_x_multi = 1.0
@export var rotation_y_multi = 1.0
@export var rotation_z_multi = 1.0

func _initial() -> void:
	can_support(
		target is Node3D, 
		"3D Rotation Component supports 'Node3D' or it's derivatives only")

func _execute() -> void:
	target = target as Node3D
	
	target.rotation.x += rotation_x_multi * get_process_delta_time()
	target.rotation.y += rotation_y_multi * get_process_delta_time()
	target.rotation.z += rotation_z_multi * get_process_delta_time()
	
func _physics_process(delta: float) -> void:
	_execute()
