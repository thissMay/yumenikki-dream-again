class_name PLHUD
extends Control

static var instance

var hide_on_pbmenu: Control
var ui_tween: Tween

@export var save_icon: TextureRect
@export var save_icon_timer: Timer

# ---- listeners ----
var hud_disable: EventListener
var hud_enable: EventListener

var hud_fade_out: EventListener
var hud_fade_in: EventListener

var invert_on_begin: EventListener
var invert_on_end: EventListener

var game_file_save: EventListener
var game_config_save: EventListener

func _ready() -> void:
	hide_on_pbmenu = get_node("hide_on_pbmenu")
	
	hud_fade_out = EventListener.new(["SCENE_CHANGE_REQUEST"], false, self)
	hud_disable = EventListener.new(["PLAYER_PRE_EQUIP", "PLAYER_PRE_DEEQUIP"], false, self)
	
	hud_fade_in = EventListener.new(["SCENE_CHANGE_SUCCESS"], false, self)
	hud_enable = EventListener.new(["PLAYER_EFFECT_EQUIP", "PLAYER_EFFECT_DEEQUIP"], false, self)

	invert_on_begin = EventListener.new(["SPECIAL_INVERT_CUTSCENE_BEGIN"], false, self)
	invert_on_end = EventListener.new(["SPECIAL_INVERT_CUTSCENE_END"], false, self)
	
	game_file_save = EventListener.new(["GAME_FILE_SAVE"], false, self)
	game_config_save = EventListener.new(["GAME_CONFIG_SAVE"], false, self)
	
	hud_fade_out.do_on_notify(func(): show_ui(self, false))
	hud_fade_in.do_on_notify(func(): show_ui(self, true))
	

	invert_on_begin.do_on_notify(func(): show_ui(hide_on_pbmenu, false))
	invert_on_end.do_on_notify(func(): show_ui(hide_on_pbmenu, true))
	
	game_config_save.do_on_notify(
		func(): 
			save_icon.texture = preload("res://src/images/config_save.png")
			show_ui(save_icon, true)
			save_icon_timer.wait_time = 1
			save_icon_timer.start()
			await save_icon_timer.timeout
			show_ui(save_icon, false)
			)	
	game_file_save.do_on_notify(
		func(): 
			save_icon.texture = preload("res://src/images/save.png")
			show_ui(save_icon, true)
			save_icon_timer.wait_time = 1
			save_icon_timer.start()
			await save_icon_timer.timeout
			show_ui(save_icon, false)
			)
	
	instance = self
	
func show_ui(_ui: Node, _show: bool) -> void:	
	if ui_tween: ui_tween.kill()
	ui_tween = _ui.create_tween()
	ui_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	match _show:
		true: 
			_ui.visible = _show
			ui_tween.tween_property(_ui, "modulate:a", 1, .5)
		false: 
			await ui_tween.tween_property(_ui, "modulate:a", 0, .5).finished
			_ui.visible = _show
	
