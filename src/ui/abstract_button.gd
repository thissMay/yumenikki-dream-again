@tool

class_name AbstractButton
extends Control

@export_group("Flags")

@export var active: bool = true:
	set(_a): 
		active = _a
		if Engine.is_editor_hint(): set_active(active)

@export_group("Unique Data")
@export var unique_data: Resource

# ---- signals ----
signal pressed
signal toggled(_truth)
signal hover_entered
signal hover_exited

@export_storage var button: BaseButton # pretty much needed.
var is_toggled: bool = false

# ---- instantiation ----
# ---- initialisation ----
func _ready() -> void:
	_setup()
	self.mouse_filter = Control.MOUSE_FILTER_PASS	
	set_active(active)
	
func _setup() -> void:
	button = GlobalUtils.get_child_node_or_null(self, "button")
	if button == null: 
		button = await GlobalUtils.add_child_node(self, Button.new(), "button")
		button.size = self.size
		button.focus_mode = Control.FOCUS_NONE
		
		button.pressed.connect(func(): pressed.emit())
		button.mouse_entered.connect(_on_hover)
		button.mouse_exited.connect(_on_unhover)
		button.button_down.connect(_on_press)
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		
		button.set_anchors_preset(PRESET_FULL_RECT)

# ---- required components / button functionality ----

func _on_hover() -> void: pass
func _on_unhover() -> void: pass

func _on_press() -> void: pass

func _on_toggle() -> void: pass
func _on_untoggle() -> void: pass

func set_active(_active: bool) -> void:
	if button != null: button.disabled = !_active
func set_button_toggle_mode(_toggle: bool) -> void:
	if button: button.toggle_mode = _toggle

func untoggle() -> void:
	button.button_pressed = false
	_on_unhover()
	_on_untoggle()
	toggled.emit(false)
func toggle() -> void:
	button.button_pressed = true
	_on_hover()
	_on_toggle()
	toggled.emit(true)
