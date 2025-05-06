extends EditorInspectorPlugin

func _can_handle(object: Object) -> bool:
	return object is Node
	
func _parse_begin(object: Object) -> void:
	var children_all = (object as Node).get_children(false)

		
