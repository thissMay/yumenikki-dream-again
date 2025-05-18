class_name BGMPlayer
extends SoundPlayer

## The 'Music Container' is going to act as a 
## container for any ambience stream player instances.
const MUSIC_DICT := {"stream" : null, "volume" : 0, "pitch" : 0, "carry_over": false}

var prev_music := MUSIC_DICT.duplicate()
var curr_music := MUSIC_DICT.duplicate()
var pending_music := MUSIC_DICT.duplicate()

var vol_tween: Tween
var pitch_tween: Tween

@onready var scene_change_request_listener := EventListener.new(["SCENE_CHANGE_REQUEST"], false, self)

func _ready() -> void:
	self.autoplay = false
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	
	scene_change_request_listener.do_on_notify("SCENE_CHANGE_REQUEST" ,func(): fade_out())

func play_sound(
	_stream: AudioStream, 
	_vol: float = 0, 
	_pitch: float = 1, 
	forget_after: bool = false) -> void:

	if playing: set_music_dict(pending_music, _stream, _vol, _pitch)
		
	set_music_dict(prev_music, curr_music["stream"], curr_music["volume"], curr_music["pitch"])
	set_music_dict(curr_music, _stream, _vol, _pitch)
	
	if same_as_previous():
		lerp_pitch(get_bgm_pitch(), self.pitch_scale)
		lerp_volume(get_bgm_volume(), self.volume_db)
	
	else:
		set_pitch(get_bgm_pitch())
		fade_in()
		set_stream(get_bgm_stream()) 
		self.play()
	
func play_music_dict(_music_dict: Dictionary) -> void:
	if _music_dict.has("stream") and _music_dict.has("volume") and _music_dict.has("pitch"):
		play_sound(
			_music_dict["stream"],
			_music_dict["volume"],
			_music_dict["pitch"])

func set_music_dict(
	_target_dict: Dictionary, 
	_stream: AudioStream, 
	_vol: float,
	_pitch: float) -> void:
		_target_dict["stream"] = _stream
		_target_dict["volume"] = _vol
		_target_dict["pitch"] = _pitch
			
# ---- getters ----
func get_bgm_volume() -> float: return curr_music["volume"]
func get_bgm_pitch() -> float:  return curr_music["pitch"]
func get_bgm_stream() -> AudioStream: return curr_music["stream"]

# ---- setters ----
func lerp_pitch(_pitch: float, _from: float = self.pitch_scale) -> void:
	if pitch_tween != null: pitch_tween.kill()
	pitch_tween = self.create_tween()	
	pitch_tween.tween_method(set_pitch, _from, _pitch, 1)
	await pitch_tween.finished
func lerp_volume(_vol: float, _from: float = self.volume_db) -> void:
	if vol_tween != null: vol_tween.kill()
	vol_tween = self.create_tween()	
	vol_tween.tween_method(set_volume, _from, _vol, 1)
	await vol_tween.finished

# ---- music control ----
func fade_in() -> void:
	if self.volume_db > -49: 
		await lerp_volume(get_bgm_volume(), self.volume_db)
		return
	await lerp_volume(get_bgm_volume(), -50)
func fade_out() -> void:
	await lerp_volume(-50, self.volume_db)
	stop()

# ---- logic ----
func same_as_previous() -> bool: 
	if prev_music and curr_music: 
		return prev_music["stream"] == curr_music["stream"]
	return false
	
