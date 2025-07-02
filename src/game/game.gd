extends Node

# ---- data ----

# inner and static class singletons
var scene_manager: SceneManager

# ---- windows
var root: Window
var main_window: Window
var main_viewport: Viewport
var main_tree: SceneTree

# ---- viewport
var viewport_width: int
var viewport_length: int
var is_paused: bool

# ---- time
var true_time_scale: float:
	set(true_ts): 
		true_time_scale = true_ts
		true_time_scale_changed.emit(true_ts)
var true_delta: float

signal time_scale_changed(_new: float)
signal true_time_scale_changed(_new: float)

static var game_manager

# ---- audio
var true_music_volume: float = 0
var true_ambience_volume: float = 0
var true_sfx_volume: float = 0

# The main game holds a child node that acts as the scene currently active.
# Upon scene change, remove the current child and queue load for the requested one.

func singleton_setup() -> void:
	scene_manager = SceneManager.new()

func _ready() -> void:	
	if Engine.is_editor_hint(): return
	
	if Optimization.override_godot_default_settings:
		Optimization.setup_overridden_project_settings()
	
	singleton_setup()
	viewport_setup()
	
	root = get_tree().root
	main_window = get_tree().root.get_window()
	main_viewport = get_tree().root.get_viewport()
	main_tree = get_tree()
	
	true_time_scale = Engine.time_scale

	render_server_setup()
	window_setup()
	
	Config.instantiate_config()
	Config.load_settings_data()
	await main_tree.process_frame
	
	instantiate_game_manager()
	game_manager.setup()
	
	scene_manager.setup()
	GlobalPanoramaManager.setup()
func _process(delta: float) -> void: 
	Game.scene_manager.handle_background_loading_upon_request(Game.scene_manager.scene_node_packed)
	GlobalPanoramaManager.update(delta)
	true_delta = get_real_delta()
	true_time_scale = get_real_timescale()

# ---- rendering server control ----
func render_server_setup() -> void:
	RenderingServer.set_default_clear_color(Color.BLACK)
func instantiate_game_manager() -> void: 
	if GameManager.instance == null:
		game_manager = preload("res://src/main/template.tscn").instantiate()
		game_manager.name = "game_manager"
		self.add_child(game_manager)
	else:
		game_manager.reparent(self)
# ---- display / window setup ---- 

func viewport_setup() -> void:
	viewport_width = get_viewport_width()
	viewport_length = get_viewport_height()
func window_setup() -> void:
	Engine.max_fps = 60
	ProjectSettings.set_setting("rendering/textures/canvas_textures/default_texture_repeat", CanvasItem.TEXTURE_REPEAT_MIRROR)

	main_window.size = Vector2(480, 270) * 3
	main_window.position = DisplayServer.window_get_size() / 6
	
	main_window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS

# ---- display / window control ---- 
func change_window_mode(new_mode: Window.Mode) -> void: main_window.mode = new_mode
func set_window_borderless(_brd: bool = true) -> void: main_window.borderless = _brd

func get_viewport_width() -> int: return ProjectSettings.get("display/window/size/viewport_width")
func get_viewport_height() -> int: return ProjectSettings.get("display/window/size/viewport_height")

func get_viewport_dimens() -> Vector2: return Vector2(viewport_width, viewport_length)

func lerp_timescale(_new: float):
	var t_tween := self.create_tween() 
	true_time_scale = _new
	t_tween.tween_method(set_timescale, Engine.time_scale, _new, 0.35)
func set_timescale(_new: float) -> void:
	Engine.time_scale = _new
	time_scale_changed.emit(_new)
	
# ---- game values ----	
func get_real_delta() -> float: 
	return (true_time_scale / Engine.max_fps)
func get_real_timescale() -> float:
	return true_time_scale
func get_timescale() -> float: return Engine.time_scale

# ---- node manipulation ----
func get_group_arr(_name: String) -> Array: 
	if main_tree.has_group(_name):
		return main_tree.get_nodes_in_group(_name)
	return []
	
class Save:
	extends GameSubClass
	static var data := {
	"game" : {
		"version" : "00",
		"read_warning" : false},
	"player" : {},
	"scene" : {}}
		
	const SAVE_PATH := "user://save.json"
	const SAVE_DIR := "user://save/"
	
	static func _setup() -> void:
		if DirAccess.dir_exists_absolute("user://save"): pass
		else: DirAccess.make_dir_absolute("user://save")
	
	static func save_data() -> Error:
		
		var save_file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
		var save_data := Dictionary(data)
		
		save_data["game"]["version"] = ProjectSettings.get_setting("application/config/version")
		save_data["player"] = Player.Data.get_data()
		save_data["scene"] = NodeSaveService.get_data()
		
		print(save_file.get_path())
		save_file.store_string(JSON.stringify(save_data))
		save_file.close()
		save_file = null
		
		GameManager.EventManager.invoke_event("GAME_FILE_SAVE")
		
		return OK
	static func load_data() -> Error:
		if FileAccess.file_exists(SAVE_PATH): 
			var load_file := FileAccess.open(SAVE_PATH, FileAccess.READ)
			var content = JSON.parse_string(load_file.get_as_text())
			data = content
			
			load_file.close()
			load_file = null
			
			Player.Data.set_data(content["player"])
			NodeSaveService.set_data(content["scene"])
			
		else: return ERR_CANT_OPEN
		return OK

	static func clear_data() -> Error:
		data["player"] = {}
		data["scene"] = {}
		data["game"]["read_warning"] = false
		return OK

	static func change_data_value(_key: String, _val: Variant) -> void:
		if !_key in data: return
		data[_key] = _val 
	static func read_data_value(_key: String) -> Variant:
		if !_key in data: return
		return data[_key]
class Config: 
	static var config_data := ConfigFile.new()
	
	static func instantiate_config() -> void:
		if get_setting_data("misc", "instantiated", true): return
		
		config_data.set_value("misc", "instantiated", true)
		
		config_data.set_value("audio", "music", db_to_linear(Audio.get_bus_volume("Music")))
		config_data.set_value("audio", "ambience", db_to_linear(Audio.get_bus_volume("Ambience")))
		config_data.set_value("audio", "se", db_to_linear(Audio.get_bus_volume("Effects")))
		
		config_data.set_value("graphics", "borderless", Game.main_window.borderless)
		config_data.set_value("graphics", "fullscreen", Game.main_window.mode == Window.MODE_FULLSCREEN)
		config_data.set_value("graphics", "motion_reduce", CameraHolder.motion_reduction)
		config_data.set_value("graphics", "bloom", GameManager.bloom)
		
		config_data.save("user://settings.cfg")
	
	static func save_settings_data() -> void: 
		GameManager.EventManager.invoke_event("GAME_CONFIG_SAVE")
		
		config_data.set_value("audio", "music", db_to_linear(Audio.get_bus_volume("Music")))
		config_data.set_value("audio", "ambience", db_to_linear(Audio.get_bus_volume("Ambience")))
		config_data.set_value("audio", "se", db_to_linear(Audio.get_bus_volume("Effects")))
		
		config_data.set_value("graphics", "borderless", Game.main_window.borderless)
		config_data.set_value("graphics", "fullscreen", Game.main_window.mode == Window.MODE_FULLSCREEN)
		config_data.set_value("graphics", "motion_reduce", CameraHolder.motion_reduction)
		config_data.set_value("graphics", "bloom", GameManager.bloom)
		
		config_data.save("user://settings.cfg")
	static func load_settings_data() -> void: 
		var s = config_data.load("user://settings.cfg")
		if s != OK: return
		
		Audio.adjust_bus_volume("Music", config_data.get_value("audio", "music"))
		Audio.adjust_bus_volume("Ambience", config_data.get_value("audio", "ambience"))
		Audio.adjust_bus_volume("Effects", config_data.get_value("audio", "se"))
		
		Game.main_window.borderless = config_data.get_value("graphics", "borderless")
		Game.main_window.mode = Window.MODE_FULLSCREEN if config_data.get_value("graphics", "fullscreen") else Window.MODE_WINDOWED
		CameraHolder.motion_reduction = config_data.get_value("graphics", "motion_reduce")
		GameManager.bloom = config_data.get_value("graphics", "bloom")
		
	static func get_setting_data(_section: String, _setting: String, _default: Variant = 0) -> Variant:
		var s = config_data.load("user://settings.cfg")
		if s != OK: return
		
		if config_data.has_section(_section) and config_data.has_section_key(_section, _setting):
			return config_data.get_value(_section, _setting)
		return _default
class Application: 
	extends GameSubClass
	static func quit(): 
		Optimization.set_max_fps(30)
		Music.fade_out()
		Ambience.fade_out()
		await Game.Save.save_data()
		await GameManager.request_transition(ScreenTransition.fade_type.FADE_IN)
		Game.main_tree.quit.call_deferred()
	
	static func pause(): 
		Game.main_tree.paused = true
		Game.is_paused = true
	static func resume(): 
		Game.main_tree.paused = false
		Game.is_paused = false
class Audio: 
	static func adjust_bus_volume(_bus_name: String, _vol: float) -> void:
		if (AudioServer.get_bus_index(_bus_name)) >= 0:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index(_bus_name), linear_to_db(_vol))
	static func get_bus_volume(_bus_name: String) -> float:
		if (AudioServer.get_bus_index(_bus_name)) >= 0:
			return AudioServer.get_bus_volume_db(AudioServer.get_bus_index(_bus_name))
		return 0

	static func adjust_bus_effect(_bus_name: String, _fx_indx: int, _fx_prop: String, _new_val: Variant):
		if ((AudioServer.get_bus_index(_bus_name)) >= 0 and 
			AudioServer.get_bus_effect_count(AudioServer.get_bus_index(_bus_name)) - 1 >= _fx_indx and
			AudioServer.get_bus_effect(AudioServer.get_bus_index(_bus_name), _fx_indx)):
			AudioServer.get_bus_effect(AudioServer.get_bus_index(_bus_name), _fx_indx).set(_fx_prop, _new_val)	
	static func add_bus_effect(_bus_name: String, _fx: AudioEffect) -> void:
		if (AudioServer.get_bus_index(_bus_name)) >= 0:			
			AudioServer.add_bus_effect(AudioServer.get_bus_index(_bus_name), _fx)
	static func remove_bus_effect(_bus_name: String, _fx_indx: int) -> void:
		if ((AudioServer.get_bus_index(_bus_name)) >= 0 and 
			AudioServer.get_bus_effect_count(AudioServer.get_bus_index(_bus_name)) - 1 >= _fx_indx and
			AudioServer.get_bus_effect(AudioServer.get_bus_index(_bus_name), _fx_indx)):
			AudioServer.remove_bus_effect(AudioServer.get_bus_index(_bus_name), _fx_indx)
	static func set_effect_active(_bus_name: String, _fx_indx: int, _active: bool) -> void:
		if ((AudioServer.get_bus_index(_bus_name)) >= 0 and 
			AudioServer.get_bus_effect_count(AudioServer.get_bus_index(_bus_name)) - 1 >= _fx_indx and
			AudioServer.get_bus_effect(AudioServer.get_bus_index(_bus_name), _fx_indx)):
			AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index(_bus_name), _fx_indx, _active)
class Optimization:
	
	static var override_godot_default_settings: bool = false
	static var footstep_instances: int = 0
	
	const FOOTSTEP_MAX_INSTANCES: int = 16
	const PARTICLES_MAX_INSTANCES: int = 128

	static func setup_overridden_project_settings() -> void:
		RenderingServer.viewport_set_default_canvas_item_texture_repeat(
			Game.main_window.get_viewport_rid(), RenderingServer.CANVAS_ITEM_TEXTURE_REPEAT_ENABLED)
		RenderingServer.viewport_set_default_canvas_item_texture_filter(
			Game.main_window.get_viewport_rid(), RenderingServer.CANVAS_ITEM_TEXTURE_FILTER_NEAREST)	
			
		Game.main_window.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
		Game.main_window.canvas_item_default_texture_repeat = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_REPEAT_ENABLED
		Game.main_window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	static func set_max_fps(_max_fps: int) -> void:
		Engine.max_fps = _max_fps
class Directory:
	static func is_path_in_dir(_path: String, _dir: String) -> bool:
		var dir_content = DirAccess.get_directories_at(_dir)
		print(dir_content)
		return _path in dir_content
	static func is_path_in_folder(_path: String) -> bool:
		return false

class GameSubClass:
	static func _setup() -> void: pass
