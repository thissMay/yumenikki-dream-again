@tool

class_name AbstractButton
extends Control

@export_group("Flags")
var is_toggled: bool = false:
	get: 
		if button: return button.button_pressed
		return false
@export var is_togglable: bool = false:
	set(_tog):
		is_togglable = _tog
		set_button_toggle_mode(_tog)
@export var disabled: bool = false

@export_group("Unique Data")
@export var unique_data: Resource

# ---- signals ----
signal pressed
signal toggled(_truth)

# ---- instantiation ----
func _components_setup_instantiation() -> void:
	button = BaseButton.new()
func _components_setup_children() -> void:
	self.add_child(button)
func _component_setup_name() -> void:
	button.name = "button"

# ---- initialisation ----
func _ready() -> void:
	_setup()
	self.mouse_filter = Control.MOUSE_FILTER_PASS
	set_button_toggle_mode(is_togglable)
	button.pressed.connect(func(): pressed.emit())
	button.size = self.size
	
func _setup() -> void:
	_components_setup_instantiation()
	_components_setup_children()
	_component_setup_name()

# ---- required components / button functionality ----
var button: BaseButton # pretty much needed.

func _on_hover() -> void: pass
func _on_unhover() -> void: pass

func _on_press() -> void: pass

func _on_toggle() -> void: pass
func _on_untoggle() -> void: pass

func set_active(_active: bool) -> void:
	button.disabled = !_active
	self.disabled = !_active
func set_button_toggle_mode(_toggle: bool) -> void:
	if button: button.toggle_mode = _toggle

func untoggle() -> void:
	button.button_pressed = false
	_on_unhover()
