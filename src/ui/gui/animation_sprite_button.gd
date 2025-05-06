@tool

class_name AnimationSpriteButton
extends AbstractButton

var animation_renderer: SpriteSheetFormatterAnimated
@export var frame_dimensions := Vector2i()
@export var fps := 1
@export var end_frame: bool = false

@export var hove_unhover: Texture2D
@export var press: Texture2D

# --- hardcoding this fucker until Im smart enough

func _ready() -> void:
	super()
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE

	button.size = self.size
	button.mouse_entered.connect(_on_hover)
	button.mouse_exited.connect(_on_unhover)
	button.button_down.connect(_on_press)
	
	_default()
	animation_renderer.fps = fps
	animation_renderer.centered = false

func _components_setup_instantiation() -> void: 
	super()
	animation_renderer = SpriteSheetFormatterAnimated.new() if animation_renderer == null else animation_renderer
func _components_setup_children() -> void: 
	super()
	self.add_child(animation_renderer)
func _component_setup_name() -> void: 
	super()
	animation_renderer.name = "sprite"

func _on_hover() -> void: 
	_default()
	animation_renderer.set_sprite(hove_unhover)
	animation_renderer.play(false)
func _on_unhover() -> void: 
	_default()
	animation_renderer.set_sprite(hove_unhover)
	animation_renderer.play(true)
func _on_press() -> void: 
	await button.pressed

	animation_renderer.set_sprite(press)
	animation_renderer.loop = true
	animation_renderer.end_frame = false
	animation_renderer.play()
	
	if is_toggled:
		button.mouse_entered.disconnect(_on_hover)
		button.mouse_exited.disconnect(_on_unhover)
	else:
		button.mouse_entered.connect(_on_hover)
		button.mouse_exited.connect(_on_unhover)


func _default() -> void:
	animation_renderer.loop = false
	animation_renderer.end_frame = end_frame
	animation_renderer.frame_dimensions = frame_dimensions
	animation_renderer.set_sprite(hove_unhover)
