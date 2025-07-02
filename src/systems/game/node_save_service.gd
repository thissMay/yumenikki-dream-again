extends Node
const SAVE_PATH := "user://save.json"

var data := {
	"scene" : {}}

var scene_data_template := {
	"scene_name" : {
		"data" 	: null,
		"id" 	: 0,
		"deleted_nodes_id" : [],
		"instantiated_nodes_id" : [],
	}
}

func save_scene_data(_scene: SceneNode) -> void: 
	var node_saves = Game.get_group_arr("node_save") as Array[NodeData]
	var stringified_scene_name: String = _scene.name as String
	
	data["scene"][stringified_scene_name] = scene_data_template["scene_name"]
	data["scene"][stringified_scene_name]["id"] = _scene.id
	
	for node in node_saves: 
		if node != null: data["scene"][stringified_scene_name]["data"] = node.save_data()			
func load_scene_data(_scene: SceneNode) -> void:
	var node_saves = Game.get_group_arr("node_save") as Array[NodeData]
	var stringified_scene_name: String = _scene.name as String
	
	if data["scene"].has(stringified_scene_name):
		for node in node_saves: 
			if node != null: node.load_data(_scene)

func get_data() -> Dictionary:
	return data
func set_data(_data) -> Error: 
	data = _data
	return OK

func change_data_value(_key: String, _val: Variant) -> void:
	if !_key in data: return
	data[_key] = _val 
func read_data_value(_key: String) -> Variant:
	if !_key in data: return
	return data[_key]
