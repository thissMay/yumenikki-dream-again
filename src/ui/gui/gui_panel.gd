# ---- 	CUSTOM PANEL HIERARCHY 	----
# -> Control
# 	-> Main Container
# 		-> Display BG
#		-> Margin Container
#			-> Icon Content Seperator
#				-> Icon Display Container
#				-> Icon Display
#				-> Inner Main Container
#					-> Text Display
# ----							----

@tool

class_name GUIPanel
extends Control

@export_category("Panel Properties")

var resize_tweener: Tween

# ---- constants ----
const MIN_SIZE = Vector2(70, 25)
const MAX_SIZE = Vector2(140, 100)

const DEFAULT_PANEL_DISPLAY_SHADER: Shader = preload("res://src/shaders/ui/button_texture_grad_mask.gdshader")
const DEFAULT_DISPLAY_BG_COLOR = Color(0,0,0,1)
var DEFAULT_PANEL_DISPLAY_TEXTURE := CanvasTexture.new()

# ---- size control ----
@export_group("Size Control")
@export var min_size: Vector2 = MIN_SIZE:
	set(min): 
		min_size = min
		custom_minimum_size = min
@export var max_size: Vector2 = MAX_SIZE:
	set(max):
		max_size = max

@export var true_size: Vector2:
	get:
		if main_container != null: return main_container.size
		return Vector2.ZERO

# ---- common vars ----
@export_group("Panel Visuals")
@export var text: String = "placeholder":
	set(_t):
		text = _t
		if Engine.is_editor_hint(): set_display_text(_t)
@export var icon: Texture2D = null:
	set(i): 
		icon = i
		if Engine.is_editor_hint(): set_icon(i)

@export var panel_stylebox_override: StyleBoxTexture:
	set(_ov):
		panel_stylebox_override = _ov
		if main_container != null: 
			if _ov: main_container.add_theme_stylebox_override("panel", _ov)
			else: main_container.remove_theme_stylebox_override("panel")
@export var panel_display_texture: Texture2D = DEFAULT_PANEL_DISPLAY_TEXTURE
@export var panel_display_color: Color = DEFAULT_DISPLAY_BG_COLOR
@export var panel_display_shader: Shader = DEFAULT_PANEL_DISPLAY_SHADER:
	set(_shader):
		panel_display_shader = _shader
		set_panel_texture_display_shader(panel_display_shader)

# ---- inner button components ---- 
@export var display_bg: TextureRect

@export var main_container: PanelContainer
@export var inner_main_container: CenterContainer
@export var icon_content_seperator: HBoxContainer

@export var margin_container: MarginContainer
@export var icon_display_container: CenterContainer
@export var icon_display: TextureRect

@export var text_display: Label

func _ready() -> void: 
	if theme == null: self.theme = preload("res://src/code_theme.tres")
	if Engine.is_editor_hint():
		await _core_setup()
		resize_panel(self.size)
		set_panel_modulate(panel_display_color)
		
	if !Engine.is_editor_hint():
		_additional_setup()
		
func _additional_setup() -> void: pass
func _core_setup() -> void:
	main_container.size = self.size
	main_container.set_anchors_preset(Control.PRESET_FULL_RECT)
		
	self.resized.connect(func(): main_container.size = self.size)
	main_container.resized.connect(func(): resize_panel(main_container.size))

	text_display.text = text
	text_display.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text_display.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	text_display.label_settings = preload("res://src/global_label_settings.tres")
	
	icon_display_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon_content_seperator.mouse_filter = Control.MOUSE_FILTER_IGNORE
	inner_main_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	main_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	display_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	display_bg.stretch_mode = TextureRect.STRETCH_SCALE
	display_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	
	icon_display.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text_display.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	margin_container.add_theme_constant_override("margin_top", 2)
	margin_container.add_theme_constant_override("margin_bottom", 2)
	margin_container.add_theme_constant_override("margin_right", 4)
	margin_container.add_theme_constant_override("margin_left", 4)
	
	display_bg.texture = CanvasTexture.new()
	display_bg.size_flags_horizontal = true
	display_bg.size.y = main_container.size.x
	display_bg.size.y = main_container.size.y
		
	set_icon(icon)
	set_panel_texture_display_shader(panel_display_shader)
	
# --- setter functions ---
func set_icon(_icon: Texture2D) -> void: 
	if icon_display != null: icon_display.texture = _icon
	if icon_display_container != null: icon_display_container.visible = (icon_display.texture != null)
	
func set_panel_texture_display_shader(_shader: Shader) -> void:
	if display_bg != null:
		display_bg.material = ShaderMaterial.new()
		display_bg.material.shader = _shader

func set_panel_modulate(_modu: Color) -> void:
	display_bg.modulate = _modu
	
func set_text(_t: String) -> void: text = _t
func set_display_text(_t: String) -> void: 
	if text_display != null: text_display.text = _t

func set_min_size(_new: Vector2) -> void: min_size = _new
func set_max_size(_new: Vector2) -> void: max_size = _new

# --- transform functions --

func resize_panel(new_size: Vector2) -> void: 
	display_bg.size = new_size
	if get_parent() is Container: min_size = (new_size)
	else: min_size = MIN_SIZE
