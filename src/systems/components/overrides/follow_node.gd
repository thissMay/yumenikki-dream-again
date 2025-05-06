class_name NodeFollower
extends Component

@export var node: Node2D
func _physics_update(_delta: float, args = []) -> void:
	receiver.affector.global_position = node.global_position
