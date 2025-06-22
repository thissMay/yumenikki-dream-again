@tool

class_name GUIPanelButton
extends GUIPanel

@export_category("Button Properties")

# ---- constants ----
var button_display_texture_shader: Shader = preload("res://src/shaders/ui/button_texture_grad_mask.gdshader")

# ---- common vars ----
@export_group("Button Visuals")

@export var button_panel_override: StyleBoxTexture:
	set(_ov):
		button_panel_override = _ov
		if main_container != null: 
			if _ov: main_container.add_theme_stylebox_override("panel", _ov)
			else: main_container.remove_theme_stylebox_override("panel")
@export var button_display_texture: Texture = CanvasTexture.new():
	set(_t):
		button_display_texture = _t
		set_button_texture(_t)

@export_group("Color Visuals")

var curr_color = Color.WHITE

@export var normal_color = Color(1, 1, 1, 1)
@export var hover_color: Color = Color(1, 0.0, 0.23, 1)
@export var disabled_color: Color = Color(0.35, 0.35, 0.45) 
@export var press_color: Color = Color(1, 1, 0, 1)

# ---- common vars ----
@export_group("Unique Data")
@export var unique_data: Resource

# ---- signals ----
signal pressed
signal toggled(_truth)
signal hover_entered
signal hover_exited


# ---- inner button components ---- 
var button: BaseButton
var modu_tw: Tween
var disp_tw: Tween

# ---- flags ---- 
@export_group("Flags")
var is_toggled: bool = false
@export var is_togglable: bool = false:
	set(_tog):
		is_togglable = _tog
		if Engine.is_editor_hint(): set_button_toggle_mode(_tog)
@export var disabled: bool = false

func _init() -> void:
	button = BaseButton.new()
	super()
func _ready() -> void: 
	super()
	set_active(!disabled)
	set_button_toggle_mode(is_togglable)
	panel_display_color = normal_color
	visibility_changed.connect(
		func():
			unhover_animation()
			set_modulate(curr_color))

	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.focus_mode = Control.FOCUS_NONE
		
func _components_children_setup() -> void: 
	super()
	
	display_bg.texture = button_display_texture
	display_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	display_bg.stretch_mode = TextureRect.STRETCH_SCALE
		
	main_container.add_child(button)
func _component_name_setups() -> void:
	super()
	button.name = "button"

func _post_ready_setup() -> void:
	display_bg.size_flags_horizontal = true
	display_bg.size_flags_horizontal = false

func _setup() -> void:	
	super()
	
	button.mouse_entered.connect(_on_hover)
	button.mouse_exited.connect(_on_unhover)
	button.button_down.connect(_on_press)

# --- visual & general behaviour functions ---
func _on_hover() -> void: 
	if !disabled:
		hover_entered.emit()
		AudioService.play_sound(preload("res://src/audio/ui/ui_button_hover.wav"), .5)
		hover_animation()
		set_button_modulate(hover_color)
func _on_unhover() -> void: 
	if !disabled:
		hover_exited.emit()
		AudioService.play_sound(preload("res://src/audio/ui/ui_button_unhover.wav"), .5)
		unhover_animation()
		set_button_modulate(normal_color)

func _on_press() -> void: 
	if !disabled:
		AudioService.play_sound(preload("res://src/audio/ui/ui_button_press.wav"))
		await press_animation()
		pressed.emit.call_deferred()

		if is_togglable:
			is_toggled = !is_toggled
			
			if is_toggled: _on_toggle()
			else: _on_untoggle() 
			
			toggled.emit(is_toggled)
	
func _on_toggle() -> void: 
	button.mouse_entered.disconnect(_on_hover)
	button.mouse_exited.disconnect(_on_unhover)
func _on_untoggle() -> void:
	button.mouse_entered.connect(_on_hover)
	button.mouse_exited.connect(_on_unhover)

# --- animations ---
func hover_animation() -> void:
	if disp_tw != null: disp_tw.kill()
	disp_tw = self.create_tween()
	
	disp_tw.set_parallel()
	disp_tw.set_ease(Tween.EASE_OUT)
	disp_tw.set_trans(Tween.TRANS_EXPO)
	disp_tw.tween_method(
		resize_display_bg, 
		display_bg.size, 
		Vector2(self.size.x, self.size.y - 4), .35)
		
	disp_tw.tween_property(text_display, "modulate:v", 1 - self.modulate.v, .35)
	disp_tw.tween_property(icon_display, "modulate:v", 1 - self.modulate.v, .35)
func unhover_animation() -> void: 
	if disp_tw != null: disp_tw.kill()
	disp_tw = self.create_tween()
		
	disp_tw.set_parallel()
	disp_tw.set_ease(Tween.EASE_OUT)
	disp_tw.set_trans(Tween.TRANS_EXPO)
	disp_tw.set_ignore_time_scale()
	
	disp_tw.tween_method(
		resize_display_bg, 
		display_bg.size, 
		Vector2(0, self.size.y - 4), .35)
		
	disp_tw.tween_property(text_display, "modulate:v", 1, .35)
	disp_tw.tween_property(icon_display, "modulate:v", 1, .35)

func press_animation() -> void:
	await set_button_modulate(normal_color, Tween.EASE_OUT, Tween.TRANS_CUBIC, 2)
	set_button_modulate(press_color, Tween.EASE_OUT, Tween.TRANS_LINEAR)
func unpress_animation() -> void:
	unhover_animation()
	set_button_modulate(normal_color)

# --- setter functions ---
func set_button_texture(_texture: Texture2D) -> void:
	display_bg.texture = _texture
func set_button_texture_display_shader(_shader: Shader) -> void:
	if display_bg != null:
		display_bg.material = ShaderMaterial.new()
		display_bg.material.shader = _shader

func set_button_modulate(
	_modu: Color, 
	_ease: Tween.EaseType = Tween.EASE_OUT, 
	_trans: Tween.TransitionType = Tween.TRANS_EXPO,
	dur: float = 10) -> void:		
	curr_color = _modu
	
	if modu_tw != null: modu_tw.kill()
	
	modu_tw = self.create_tween()
	modu_tw.set_ease(_ease)
	modu_tw.set_trans(_trans)
	modu_tw.set_parallel()
	modu_tw.set_ignore_time_scale()
	
	modu_tw.tween_method(set_modulate, self.modulate, _modu, dur * get_process_delta_time())
		
	await modu_tw.finished


func set_button_toggle_mode(_toggle: bool) -> void:
	if button != null:
		button.toggle_mode = _toggle

func set_active(_a: bool) -> void:
	button.disabled = !_a
	self.disabled = !_a
	match _a:
		true: set_button_modulate(normal_color)
		false: set_button_modulate(disabled_color)

# ---- exclusive ----
func resize_display_bg(_new: Vector2) -> void:
		display_bg.size = _new


# ---- INITALIZATION OVERRIDES ----
func resize_panel(new_size: Vector2) -> void: 
	display_bg.size = (Vector2(0, new_size.y))
	if get_parent() is Container: min_size = (new_size)
	else: min_size = MIN_SIZE
