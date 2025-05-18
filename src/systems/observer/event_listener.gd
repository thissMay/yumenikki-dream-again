class_name EventListener
extends Object

var events_listening_to: Array[String]

var is_static: bool
var node_owner: Node
var actions: Dictionary

func _init(_id: Array[String] = [""], _static: bool = false, _owner: Node = null) -> void:
	is_static = _static
	node_owner = _owner
	for i in _id:
		listen_to_event(i)

func on_notify(_id: String) -> void: # --- called from the event_manager.
	if _id in GameManager.event_ids:
		if _id in actions and actions[_id] and (is_instance_valid(node_owner) or is_static): 
			actions[_id].call_deferred()
		
func do_on_notify(_event_id: String, _do := Callable()) -> void: 
	if _event_id in GameManager.event_ids and _event_id in events_listening_to:
		actions[_event_id] = Callable(_do)

func listen_to_event(_event_id: String):
	if _event_id in GameManager.event_ids:
		GameManager.event_ids[_event_id]["subscribers"].append(self)
		events_listening_to.append(_event_id)
		
func is_valid_listener() -> bool:
	return ((is_static and node_owner == null) or (node_owner != null))
