class_name SoundPlayer
extends AudioStreamPlayer

var pre_mute_vol: float = 0
var pre_mute_pit: float = 1
var was_playing: bool = false

const ZERO_VOLUME = -50

@export var muted: bool = false
@export var affected_by_timescale: bool = false:
	set(_is_affected):
		affected_by_timescale = _is_affected
		match _is_affected:
			true: Game.true_time_scale_changed.connect(set_timescale_factor)
			false: Game.true_time_scale_changed.disconnect(set_timescale_factor)
var timescale_factor: float = 0

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	
func play_sound(
	_stream: AudioStream, 
	_vol: float = 0, 
	_pitch: float = 1, 
	forget_after: bool = false) -> void:
	if _stream and not muted: 
		if ResourceLoader.exists(_stream.resource_path):
			if playing: stop()
			stream = _stream
			volume_db = _vol
			pitch_scale = _pitch
			play()
			await finished
func mute() -> void: 
	pre_mute_vol = volume_db
	pre_mute_pit = pitch_scale
	
	volume_db = ZERO_VOLUME
	was_playing = playing
	stop()
func unmute() -> void:
	if was_playing: play()
	volume_db = pre_mute_vol
	pitch_scale = pre_mute_pit

# ---- setters ----
func set_timescale_factor(_fac: float) -> void: self.timescale_factor = _fac

func set_pitch(_pitch: float) -> void: self.pitch_scale = clampf(_pitch, 0.1, 5)
func set_volume(_vol: float) -> void: self.volume_db = _vol

# ---- getters ----
func get_pitch() -> float: return self.pitch_scale
