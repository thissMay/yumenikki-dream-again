class_name IngameSettings
extends Control

@export var music_slider: HSlider
@export var amb_slider: HSlider
@export var sfx_slider: HSlider

@export var borderless: CheckBox
@export var full_screen: CheckBox
@export var cam_reduction: CheckBox
@export var bloom: CheckBox

@export var resume: GUIPanelButton
@export var quit_to_menu: GUIPanelButton
@export var quit_to_desktop: GUIPanelButton

func _ready() -> void:
	
	music_slider.value = Game.Config.get_setting_data("audio", "music", 1)
	amb_slider.value = Game.Config.get_setting_data("audio", "ambience", 1)
	sfx_slider.value = Game.Config.get_setting_data("audio", "se", 1)
	
	borderless.button_pressed = Game.Config.get_setting_data("graphics", "borderless", false)
	full_screen.button_pressed = Game.Config.get_setting_data("graphics", "fullscreen", false)
	cam_reduction.button_pressed = Game.Config.get_setting_data("graphics", "motion_reduce", false)
	bloom.button_pressed = Game.Config.get_setting_data("graphics", "bloom", false)

	setup()
	
	
func setup() -> void:
	music_slider.value_changed.connect(func(_val: float):
		Game.Audio.adjust_bus_volume("Music", clamp(_val, 0, 1)))
	amb_slider.value_changed.connect(func(_val: float):
		Game.Audio.adjust_bus_volume("Ambience", clamp(_val, 0, 1)))
	sfx_slider.value_changed.connect(func(_val: float):
		Game.Audio.adjust_bus_volume("Effects", clamp(_val, 0, 1)))

	borderless.toggled.connect(func(_truth: bool): Game.set_window_borderless(_truth))
	full_screen.toggled.connect(func(_truth: bool): 
		Game.change_window_mode(Window.MODE_FULLSCREEN) if _truth else Game.change_window_mode(Window.MODE_WINDOWED))
	cam_reduction.toggled.connect(func(_truth: bool): 
		CameraHolder.motion_reduction = _truth)
	bloom.toggled.connect(func(_truth: bool): 
		GameManager.global_screen_effect.environment.glow_enabled = _truth
		GameManager.bloom = _truth)
			
	quit_to_menu.pressed.connect(
		func(): 
			GameManager.change_scene_to(preload("res://src/levels/_neutral/menu/menu.tscn"))
			GameManager.pause_options(false)
			GameManager.pause(false)
			)		
	quit_to_desktop.pressed.connect(
		func(): Game.Application.quit())
	resume.pressed.connect(
		func(): 
			Game.Config.save_settings_data()
			GameManager.pause_options(false))

#func on_show() -> void:
	#if Game.scene_manager.scene_node_packed == load("res://src/scenes/menu/menu.tscn"):
		#quit_to_menu.set_active(false)
	#else:
		#quit_to_menu.set_active(true)
