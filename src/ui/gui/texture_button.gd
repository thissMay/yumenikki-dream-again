@tool

class_name GUITextureButton
extends AbstractButton

var texture_renderer: SpriteSheetFormatter
@export var texture: Texture2D
@export var frame_dimensions: Vector2i
@export var style: SpriteSheetFormatter.style

@export var unhover_cell: int
@export var hover_cell: int
@export var press_cell: int

func _components_setup_instantiation() -> void:
	super()
	texture_renderer = SpriteSheetFormatter.new()
func _components_setup_children() -> void:
	super()
	self.add_child(texture_renderer)
func _component_setup_name() -> void:
	super()
	texture_renderer.name = "texture"
	
func _setup() -> void:
	super()
	texture_renderer.frame_dimensions = frame_dimensions
	texture_renderer.texture = texture
	texture_renderer.strip_style = style
	texture_renderer.centered = false
	
	texture_renderer.progress = unhover_cell if GlobalUtils.is_within_exclusive(unhover_cell, 0, 3) else 0

func _on_hover() -> void: texture_renderer.progress = hover_cell
func _on_unhover() -> void: texture_renderer.progress = unhover_cell
func _on_press() -> void: texture_renderer.progress = press_cell
