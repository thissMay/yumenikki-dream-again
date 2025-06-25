class_name SceneManager extends Object

var scene_node: SceneNode
var scene_node_packed: PackedScene:
	get: 
		if scene_node != null: return load(scene_node.scene_file_path)
		else: return null
var prev_scene_ps: PackedScene

var additive_scene_node: SceneNode
var additive_scene_node_packed: PackedScene
var prev_additive_node_ps: PackedScene

var initial_scene_setup_complete: bool = false
var scene_change_pending: bool = false

# ---------- 	BACKGROUND LOADING 		---------- #
var load_requested: bool = false
var bg_load_finished: bool = false

var load_progress: Array[int]
var scene_load_err_check: Error
var scene_load_status: ResourceLoader.ThreadLoadStatus

var instantiated_scene: SceneNode = null
var result: ResourceLoader.ThreadLoadStatus

func handle_background_loading_upon_request(scene: PackedScene) -> ResourceLoader.ThreadLoadStatus:
	if !load_requested or bg_load_finished: return ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED
	if scene == scene_node_packed or !ResourceLoader.exists(scene.resource_path): return ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED
	
	scene_load_status = ResourceLoader.load_threaded_get_status(scene.resource_path, load_progress)
	print("LOADING PROGRESS: ", load_progress)
	
	if scene_load_err_check == OK:
		match scene_load_status:
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_INVALID_RESOURCE: ## 0
				print_rich("[b]SceneManager // Loading :: Scene (as resource) is invalid. Please check the resource's status.[/b]")
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED: ## 2
				print_rich("[b]SceneManager // Loading :: Scene loading has failed.[/b]")
				bg_load_finished = true
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED: ## 3
				print_rich("[b]SceneManager // Loading :: what.[/b]")
				bg_load_finished = true
	
	return scene_load_status
func setup() -> void: 
	
	if !initial_scene_setup_complete and scene_node != null: 
		if GameManager.instance == null: scene_node.reparent(Global)
		else: scene_node.reparent(GameManager.pausable_parent)
		
		scene_node_packed = load(scene_node.scene_file_path)
		scene_node.on_load()
		initial_scene_setup_complete = true
		

# ---------- 	SCENES LOADER / UNLOADERS 		---------- #
func unload_current_scene() -> bool:
	if scene_node: 	return unload_scene(scene_node)
	return false
func unload_scene(scene: SceneNode) -> bool:
		scene.queue_free()
		GameManager.EventManager.invoke_event("SCENE_UNLOADED")
		print_rich("[b]SceneManager // Unloading : Scene Unloaded![/b]")
			
		return true 
func load_scene(scene: PackedScene, root_node: Node, backup_root_node: Node = null) -> void:
	if ResourceLoader.exists(scene.resource_path) && scene.can_instantiate():
		prev_scene_ps = scene_node_packed
		
		scene_load_err_check = ResourceLoader.load_threaded_request(scene.resource_path)
		
		instantiated_scene = null
		load_requested = true
		bg_load_finished = false
		
		result = await handle_background_loading_upon_request(scene)
		
		if result == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			instantiated_scene = scene.instantiate()
			scene_node = instantiated_scene
			
			if root_node != null: root_node.add_child(instantiated_scene)
			else: backup_root_node.add_child(instantiated_scene)
			
			GameManager.EventManager.invoke_event("SCENE_LOADED")
			scene_node.on_load()
					
		load_requested = false
		bg_load_finished = true
		
		
		print(str("SceneManager // Load Status: ", scene_load_status))
		print_rich("[b]SceneManager // Loading :: Loading Scene was a success![/b]")
		print_rich("[b]SceneManager // Loading :: Scene Loaded : [/b]", scene)

	else: scene_node_packed = null

func get_curr_scene() -> SceneNode: return scene_node

func get_curr_packed_scene() -> PackedScene: return scene_node_packed
func get_prev_packed_scene() -> PackedScene: return prev_scene_ps

func get_curr_additive_packed_scene() -> PackedScene: return null
func get_prev_additive_packed_scene() -> PackedScene: return null

func change_scene_to
(
	scene: PackedScene, 
	root_node: Node, 
	backup_root_node: Node = null	
) -> void:
		if scene_node and scene and scene != scene_node_packed:
			if !scene_change_pending:
				prev_scene_ps = scene_node_packed
				scene_change_pending = true

				GameManager.EventManager.invoke_event("SCENE_CHANGE_REQUEST")
				scene_node.on_unload_request()
				await ScreenTransition.request_transition(ScreenTransition.fade_type.FADE_IN)
				scene_node.on_unload()
				await unload_current_scene()
				
				if ResourceLoader.exists(scene.resource_path):
					await load_scene(scene, root_node, backup_root_node)
					print_rich("[color=green]SceneManager // Scene Change :: Success.[/color]")
					GameManager.EventManager.invoke_event("SCENE_CHANGE_SUCCESS", [scene.resource_path])

				await ScreenTransition.request_transition(ScreenTransition.fade_type.FADE_OUT)
				scene_change_pending = false
				
		else: 
			GameManager.EventManager.invoke_event("SCENE_CHANGE_FAIL")
			print_rich("[color=yellow]SceneManager // Scene Change :: Scene does not exist. [/color]")

# ---------- 									---------- #
# ----
# here are the scene events called in order:
#	1. -> SCENE_CHANGE_REQUEST
#			-> called prior to unloading.
#	2. -> SCENE_UNLOADED
#	3. -> SCENE_LOADED
#			-> called prior to loading.
#	4. -> SCENE_CHANGE_SUCESS / SCENE_CHANGE_FAIL
#			-> called after loading.
# ----
