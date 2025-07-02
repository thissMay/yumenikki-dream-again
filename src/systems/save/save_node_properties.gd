class_name NodeSaver
extends NodeData

@export var properties: Array[String]

var parent: Node
var data := {"prop" : {} }


# ---- load (props) ----
func load_data(_scene: SceneNode) -> Error:
	parent = get_parent()
	if parent == null: return ERR_UNAVAILABLE
		
	# we are going to fetch it from game lol.
	
	if properties:
		var saved_data = NodeSaveService.data["scene"][_scene.name]["data"]["prop"]
		for prop in saved_data:
			parent.set_indexed(prop, saved_data.get(prop))
			
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
