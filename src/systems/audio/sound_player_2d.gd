@tool

class_name SoundPlayer2D
extends AudioStreamPlayer2D

var pre_mute_vol: float = 0
var pre_mute_pit: float = 1
var was_playing: bool = false

const ZERO_VOLUME_LIN 	= 0
const ZERO_VOLUME_DB 	= -80

var vol_max_clamp: float = INF

@export var muted: bool = false
@export var affected_by_timescale: bool = false:
	set(_is_affected):
		affected_by_timescale = _is_affected
		if Engine.is_editor_hint(): return
	
		match _is_affected:
			true: 	Utils.connect_to_signal(set_timescale_factor, Game.true_time_scale_changed)
			false: 	Utils.disconnect_from_signal(set_timescale_factor, Game.true_time_scale_changed)
var timescale_factor: float = 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	
func play_sound(
	_stream: AudioStream, 
	_vol: float = 1, 
	_pitch: float = 1) -> void:
	if _stream and !muted: 
		if ResourceLoader.exists(_stream.resource_path):
			if playing: stop()
			
			stream 			= _stream
			volume_linear 	= _vol
			pitch_scale 	= _pitch
			
			play()
			await finished
func mute() -> void: 
	pre_mute_vol 	= volume_linear
	pre_mute_pit 	= pitch_scale
	volume_linear 	= ZERO_VOLUME_LIN
	
func unmute() -> void:
	volume_linear 	= pre_mute_vol
#
#func _draw() -> void:
	#if Engine.is_editor_hint():
		##draw_circle(Vector2.ZERO, max_distance, Color(Color.RED, 0.05))

# ---- setters ----
func set_timescale_factor(_fac: float) -> void: self.timescale_factor = _fac

func set_pitch(_pitch: float) -> void: self.pitch_scale = clampf(_pitch, 0.1, 5)
func set_volume(_vol: float) -> void: self.volume_db = _vol

# ---- getters ----
func get_pitch() -> float: return self.pitch_scale

# --- ---- 
func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		queue_redraw()
