@tool
extends EditorPlugin


var curr_editing_scene = get_tree().edited_scene_root

func _enter_tree() -> void:
	curr_editing_scene = get_tree().edited_scene_root
	curr_editing_scene.child_entered_tree.connect(_print_node_info)
	print(get_tree().root.get_child(0))	
	

func _print_node_info(_node: Node) -> void:
	if _node.get_parent() == null: return 
	_node.owner = curr_editing_scene
	print(_node.owner)
	for n in _node.get_children(true): # --- children of nodes of the scene
		print(n.owner)

func _exit_tree() -> void:
	curr_editing_scene = null
	curr_editing_scene.child_entered_tree.disconnect(_print_node_info)	
	

func set_owner_to_scene_root(_node: Node) -> void: 
	if _node.owner == null: _node.owner = get_tree().edited_scene_root

func _handles(_obj: Object) -> bool: return _obj is Node 
