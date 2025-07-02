@tool
class_name GlobalUtils
extends EditorPlugin

func _handles(object: Object) -> bool:
	return object is Node

static func is_within_exclusive(_num: float, _min: float, _max: float) -> bool:
	return ((_num < _min) and (_num > _max))
static func is_within_inclusive(_num: float, _min: float, _max: float) -> bool:
		return ((_num <= _min) and (_num >= _max))

static func add_child_node(
	_parent_node: Node,
	_child_node: Node,
	_child_node_name: String) -> Node:
		
		if _child_node == null: return
		if !_parent_node.has_node(_child_node_name):
			
			if Engine.is_editor_hint(): 
				await EditorInterface.get_edited_scene_root().get_tree().process_frame
			_parent_node.add_child(_child_node)
			_child_node.name = _child_node_name
			_child_node.owner = EditorInterface.get_edited_scene_root()
			
			return _child_node
		else:
			printerr("Parent %s already has child... Freeing %s." % [_parent_node, _child_node])
			_child_node.queue_free()
			return _parent_node.get_node(_child_node_name)
		return
static func get_child_node_or_null(
	_parent_node: Node, 
	_child_node_name: String) -> Node: 
		
		if _parent_node == null: return null
		return _parent_node.get_node_or_null(_child_node_name)


class Predicate:
	static func evaluate(_expression: bool) -> bool: return _expression
