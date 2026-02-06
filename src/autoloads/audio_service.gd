@tool
extends SoundPlayer

var s: Stack
const SIZE: int = 50

func _ready() -> void: super()
func _enter_tree() -> void:
	s = Stack.new(SIZE, false)
	
	for i in range(SIZE):
		var sound = SoundPlayer.new()
		sound.bus = Audio.BUS_ENV 
		s.push(sound)
		self.add_child(sound)
		
func play_sound_unique_stream(
	_stream: AudioStream, 
	_vol: float = 1, 
	_pitch: float = 1) -> void:
		
		if !s.is_empty():
			var sound = (s.pop() as SoundPlayer)
			
			sound.finished.connect(func(): s.push(sound))
			sound.play_sound(_stream, _vol, _pitch)

func _notification(what: int) -> void: 
	if 	what == NOTIFICATION_WM_WINDOW_FOCUS_IN or \
		what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		stop()

func play_test_audio_from(
	_bus_name: String,
	_stream: AudioStream, 
	_vol: float = 1, 
	_pitch: float = 1) -> void:
		if Audio.has_bus_name(_bus_name): bus = _bus_name
		play_sound(_stream, _vol, _pitch)
	
