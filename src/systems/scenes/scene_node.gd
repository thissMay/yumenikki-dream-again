class_name SceneNode
extends Node

const ID_NUMS = "0123456789"
const ID_ALPHA = "abcdefghijklmnopqrstuvwxyzABCEDFGHIJKLMNOPQRSTUVWXYZ"
var id: String

func set_node_active(active: Node.ProcessMode) -> void:
	self.set_process_mode.call_deferred(active)

# ---- on load / unload ----
func _ready() -> void: 
	generate_id()
	Game.scene_manager.scene_node = self
func _enter_tree() -> void: pass

func on_load() -> void: 
	_on_load()
func on_load_request() -> void: 
	_on_unload_request()
	set_node_active(Node.PROCESS_MODE_INHERIT)

func on_unload() -> void: 
	_on_unload()
func on_unload_request() -> void: 
	_on_unload_request()
	set_node_active(Node.PROCESS_MODE_DISABLED)

func generate_id() -> void:
	for i in range(5): id += ID_NUMS[randi_range(0, ID_NUMS.length() - 1)]
	for i in range(5): id += ID_ALPHA[randi_range(0, ID_ALPHA.length() - 1)]

func _on_load() -> void: pass
func _on_load_request() -> void: pass 

func _on_unload() -> void: pass 
func _on_unload_request() -> void: pass 
