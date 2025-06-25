@tool
extends Event

var node: Node
@export var method: Array[Dictionary]

func _ready() -> void:
	if node == null: return
	method = node.get_method_list()
func _execute() -> void: pass
