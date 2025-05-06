@tool
class_name SpriteSheetFormatter
extends Sprite2D

# helpful if you wanna format it on the fly
@export_tool_button("Format") var formatter = refresh_frame_splitting

@export var frame_dimensions: Vector2i

@export var frame_h_count	: int = 1
@export var frame_v_count	: int = 1

@export var progress: int = 0:
	set(p): progress = wrap(p, 0 , frame_h_count)
var row: float = 0
var cached_row: float = 0
var within_bounds: bool = false

func _ready() -> void: 
	texture_changed.connect(format)
	refresh_frame_splitting()
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
	
	if within_bounds: cached_row = row
	else: cached_row = _r

func check_row() -> void:
	if row <= frame_v_count - 1: pass
	else: row = frame_v_count - 1
func attempt_row() -> void:
	row = cached_row if cached_row <= frame_v_count - 1 else row

func _process(delta: float) -> void:
	frame_coords.x = clamp(round(progress), 0, frame_h_count)
	frame_coords.y = clamp(round(row), 		0, frame_v_count)
	within_bounds = cached_row <= frame_v_count - 1
