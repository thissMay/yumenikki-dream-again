@tool

class_name SpriteSheetFormatterAnimated
extends SpriteSheetFormatter

@export_category("Spritesheet Animation")

# ---- animation flags ----
@export_group("Play Properties")
var playing: bool = false
@export var autoplay: bool = false:
	set(_auto):
		autoplay = _auto
		if Engine.is_editor_hint(): playing = _auto
@export var loop: bool = false

@export var reverse: bool = false
@export var end_frame: bool = false

var reached_end: bool = false
var reached_first: bool = false

# ---- time ----
@export_group("Animation Properties")
@export var fps: float = 1
var time_elapsed: float = 0

# ---- signals ----s
signal animation_loop
signal animation_finished

func _ready() -> void:
	if autoplay: play(texture)
	animation_loop.connect(func(): if !loop: playing = false)
	super()
func format(_spr: Texture2D = texture) -> void:
	super(_spr)


func play(_sprite: Texture2D, _reverse: bool = false) -> void:
	set_sprite(_sprite)
	playing = true
	progress = 0 if !_reverse else frame_h_count - 1
	reverse = _reverse
	
func _process(delta: float) -> void:
	super(delta)
	if playing:
		time_elapsed += delta
		
		if (time_elapsed > 1 / fps ):
			progress = progress + 1 if !reverse else progress - 1
			time_elapsed = 0
						
			if progress == 0: 
				if end_frame: progress = 0 if reverse else frame_h_count - 1 
				animation_loop.emit()
				animation_finished.emit()
				
			reached_end = progress == frame_h_count - 1
			reached_first = progress == 0
