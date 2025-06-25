class_name GameScene
extends SceneNode

@export var rules: Array[SceneRule]

@onready var save_invoker := EventListener.new(["SCENE_CHANGE_REQUEST"], false, self)
@export var load_transition: ShaderMaterial = ShaderMaterial.new()
@export var unload_transition: ShaderMaterial = ShaderMaterial.new()
				
func _ready() -> void: 
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
	
