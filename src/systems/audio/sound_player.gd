class_name SoundPlayer
extends AudioStreamPlayer

# everything moving forward with this will use the LINEAR volume
# and not DB.

var pre_mute_vol: float = 0
var pre_mute_pit: float = 1
var was_playing: bool = false

const ZERO_VOLUME_LIN 	= 0
const ZERO_VOLUME_DB 	= -80

var vol_max_clamp: float = INF
var vol_min_clamp 

@export var muted: bool = false
@export var affected_by_timescale: bool = false:
	set(_is_affected):
		affected_by_timescale = _is_affected
		match _is_affected:
			true: Game.true_time_scale_changed.connect(set_timescale_factor)
			false: Game.true_time_scale_changed.disconnect(set_timescale_factor)
var timescale_factor: float = 0

func _ready() -> void: process_mode = Node.PROCESS_MODE_PAUSABLE
func _notification(what: int) -> void:
	if what == NOTIFICATION_PAUSED: mute()
	if what == NOTIFICATION_UNPAUSED: unmute()
	
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
	pitch_scale 	= pre_mute_pit

# ---- setters ----
func set_timescale_factor(_fac: float) -> void: self.timescale_factor = _fac

func set_pitch(_pitch: float) -> void: 			self.pitch_scale 	= clampf(_pitch, 0.1, 5)
func set_volume(_db_vol: float) -> void:  		self.volume_db 		= clampf(_db_vol, ZERO_VOLUME_DB, 5)
func set_volume_lin(_lin_vol: float) -> void:  	self.volume_linear 	= clampf(_lin_vol, ZERO_VOLUME_LIN, 2)

# ---- getters ----
func get_pitch() -> float: return self.pitch_scale
