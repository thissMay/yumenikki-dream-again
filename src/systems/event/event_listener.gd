class_name EventListener
extends Object

var events_listening_to: Array[String]

var is_static: bool
var node_owner: Node
var action := Callable()

func _init(_id: Array[String] = [""], _static: bool = false, _owner: Node = null) -> void:
	is_static = _static
	node_owner = _owner
	for i in _id:
		listen_to_event(i)

func on_notify() -> void:
	if action and (is_instance_valid(node_owner) or is_static): 
		action.call_deferred()
		
func do_on_notify(_do := Callable()) -> void: 
	action = Callable(_do)

func listen_to_event(_event_id: String):
	if _event_id in GameManager.event_ids:
		GameManager.event_ids[_event_id]["subscribers"].append(self)
		events_listening_to.append(_event_id)
		
func is_valid_listener() -> bool:
	return ((is_static and node_owner == null) or (node_owner != null))
