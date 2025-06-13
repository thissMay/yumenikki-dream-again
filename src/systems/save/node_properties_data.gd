class_name NodeSaver
extends Node

@export var properties: Array[String]

var parent: Node
var data := {"prop" : {} }

@onready var save_invoker := EventListener.new(["SCENE_CHANGE_REQUEST"], false, self)

func _ready() -> void:
	add_to_group("node_savers")


# ---- load (props) ----
func load_data(_scene: SceneNode) -> Error:
	parent = get_parent()
	if parent == null: return ERR_UNAVAILABLE
		
	# we are going to fetch it from game lol.
	if properties:
		for p in Game.data["scene"][_scene.name]["data"]["prop"]:
			parent.set_indexed(p, Game.data["scene"][_scene.name]["data"]["prop"].get(p))
			
		return OK
	return ERR_DOES_NOT_EXIST

# ---- save (props) ----
func save_data() -> Dictionary:
	parent = get_parent()
	if parent == null: return {}
	
	for p : NodePath in properties: 
		parent.get_indexed(p)
		data["prop"][p] = parent.get_indexed(p)
	
	return data
