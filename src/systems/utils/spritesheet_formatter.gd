@tool
class_name SpriteSheetFormatter
extends Sprite2D

enum style {HORIZONTAL, VERTICAL}
@export var strip_style: style = style.HORIZONTAL

# helpful if you wanna format it on the fly
@export_tool_button("Format") var formatter = refresh_frame_splitting

@export var frame_dimensions: Vector2i:
	set(_dims):
		if Engine.is_editor_hint(): frame_dimensions = _dims.clamp(Vector2i.ZERO, texture.get_size())
		else: frame_dimensions = _dims

@export var frame_h_count	: int = 1
@export var frame_v_count	: int = 1

@export var progress: int = 0:
	set(p): 
		match strip_style:
			style.HORIZONTAL: 	progress = wrap(p, 0 , frame_h_count)
			style.VERTICAL: 	progress = wrap(p, 0 , frame_v_count)

var column: float
var cached_column: float
var column_within_bounds: bool = false

var row: float = 0
var cached_row: float = 0
var row_within_bounds: bool = false

func _ready() -> void: 
	texture_changed.connect(format)
	visibility_changed.connect(func(): set_process(self.visible))

func refresh_frame_splitting() -> void:
	format()
	
func format(_spr: Texture2D = texture) -> void:	
	if _spr:
		progress = 0 
		
		frame_h_count = int(_spr.get_width() / clampi(frame_dimensions.x, 1, frame_dimensions.x))
		frame_v_count = int(_spr.get_height() / clampi(frame_dimensions.y, 1, frame_dimensions.y))
	 
		check_row()
		attempt_row()
		
		self.hframes = clamp(frame_h_count, 1, frame_h_count)
		self.vframes = clamp(frame_v_count, 1, frame_v_count)
func set_sprite(_spr: Texture2D) -> void:
	format(_spr)
	if _spr: texture = _spr
func set_row(_r: float) -> void:
	if row <= frame_v_count - 1: row = clamp(_r, 0, frame_v_count - 1)
	else: row = frame_v_count - 1
	
	if row_within_bounds: cached_row = row
	else: cached_row = _r

func check_row() -> void:
	if row <= frame_v_count - 1: pass
	else: row = frame_v_count - 1
func attempt_row() -> void:
	row = cached_row if cached_row <= frame_v_count - 1 else row

func _process(delta: float) -> void:
	match strip_style:
		style.HORIZONTAL:
			frame_coords.x = clamp(round(progress), 0, frame_h_count)
			frame_coords.y = clamp(snapped(row, 0.5), 		0, frame_v_count)
			row_within_bounds = cached_row <= frame_v_count - 1
		style.VERTICAL:
			frame_coords.x = clamp(round(column), 	0, frame_h_count)
			frame_coords.y = clamp(round(progress),	0, frame_v_count)
			column_within_bounds = cached_column <= frame_h_count - 1
