@tool

class_name SpriteSheetFormatterAnimated
extends SpriteSheetFormatter

@export_category("Animation Properties")

# ---- animation flags ----
@export var autoplay: bool = false
@export var playing: bool = false
@export var loop: bool = false

@export var reverse: bool = false
@export var end_frame: bool = false
@export var ping_pong: bool = false

var ping_ponged: bool = false
var reached_end: bool = false
var reached_first: bool = false

# ---- time ----
@export var fps: float = 1
var time_elapsed: float = 0

# ---- signals ----s
signal animation_loop
signal animation_finished

func _ready() -> void:
	if autoplay: play()
	animation_loop.connect(func(): if !loop: playing = false)
	super()
func format(_spr: Texture2D = texture) -> void:
	super(_spr)


func play(_reverse: bool = false) -> void:
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
