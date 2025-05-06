extends ResourceCommand

var obj: Object:
	get: return Game.get_node_obj(obj_path)
@export var obj_path: NodePath 
@export var visible: bool
func _execute() -> void: obj.set_indexed("visible", visible)
