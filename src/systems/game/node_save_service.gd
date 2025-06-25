extends Node
const SAVE_PATH := "user://save.json"

var data := {
	"game" : {
		"version" : "prev_00_01",
		"id" : 0,
		"read_warning" : false},
	"player" : {},
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
	var node_saves = Game.get_group_arr("node_saves") as Array[NodeData]
	
	data["scene"][_scene.name] = {"data" : null, "id" : _scene.id}
	for node in node_saves: 
		if node != null: data["scene"][_scene.name]["data"] = node.save_data()		
func load_scene_data(_scene: SceneNode) -> void:
	var node_saves = Game.get_group_arr("node_saves") as Array[NodeData]
	
	if data["scene"].has(_scene.name):
		for node in node_saves: 
			if node != null: node.load_data()



func change_data_value(_key: String, _val: Variant) -> void:
	if !_key in data: return
	data[_key] = _val 
func read_data_value(_key: String) -> Variant:
	if !_key in data: return
	return data[_key]
