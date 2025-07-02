@tool

class_name GameScene
extends SceneNode

@export var rules: Array[SceneRule]
@export_storage var scene_load_sequence: Sequence
@export_storage var scene_unload_sequence: Sequence

@onready var save_invoker := EventListener.new(["SCENE_CHANGE_REQUEST"], false, self)
@export var load_transition: ShaderMaterial = ShaderMaterial.new()
@export var unload_transition: ShaderMaterial = ShaderMaterial.new()

func _ready() -> void: 
	
	if Engine.is_editor_hint():
		if GlobalUtils.get_child_node_or_null(self, "scene_unload_seq") != null:
			GlobalUtils.get_child_node_or_null(self, "scene_unload_seq").queue_free()
		if GlobalUtils.get_child_node_or_null(self, "scene_load_seq") != null:
			GlobalUtils.get_child_node_or_null(self, "scene_load_seq").queue_free()
		
		scene_load_sequence = GlobalUtils.get_child_node_or_null(self, "scene_load_sequence")
		scene_unload_sequence = GlobalUtils.get_child_node_or_null(self, "scene_unload_sequence")
		
		if scene_load_sequence == null: scene_load_sequence = await GlobalUtils.add_child_node(self, Sequence.new(), "scene_load_sequence")
		if scene_unload_sequence == null: scene_unload_sequence = await GlobalUtils.add_child_node(self, Sequence.new(), "scene_unload_sequence")
	
	if !Engine.is_editor_hint():
		super()
	
		if load_transition == null: 
			load_transition = ShaderMaterial.new()
			load_transition.material = preload("res://src/shaders/transition/tr_fade.gdshader")
		if unload_transition == null:
			unload_transition = ShaderMaterial.new()
			unload_transition.material = preload("res://src/shaders/transition/tr_fade.gdshader")
	
		ScreenTransition.set_fade_out_shader(load_transition)
		ScreenTransition.set_fade_in_shader(unload_transition)
		
		save_invoker.do_on_notify("SCENE_CHANGE_REQUEST", save_scene)

func _on_load() -> void: 
	load_scene()
	save_scene()
	
	for _r in rules: _r.apply_on_scene_load()
func _on_unload() -> void:
	super()
	for _r in rules: _r.unapply_on_scene_unload()

# ---- saving. 
func save_scene() -> void: NodeSaveService.save_scene_data(self)
func load_scene() -> void: NodeSaveService.load_scene_data(self)
	
