extends Node

@export var node_event: ResourceEvent
@export var node_to_pass: Node

func _ready() -> void:
	if node_event != null and node_to_pass != null:
		node_event.node = node_to_pass
