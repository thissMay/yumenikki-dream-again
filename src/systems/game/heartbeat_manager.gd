extends Component

var sound_player: SoundPlayer
var trauma: ShaderMaterial

func _ready() -> void:
	trauma = get_node("trauma/fx").material
	
	sound_player = $sound
	sound_player.stream = preload("res://src/audio/se/se_heartbeat.wav")
	sound_player.play()
	
	set_active(active)

func _process(delta: float) -> void:
	if PLInstance.get_pl() != null:
		sound_player.volume_db = lerpf(
			sound_player.volume_db, -50 + (1.08 * (PLInstance.get_pl().get_bpm() - 60)), 
			delta * 3.2)
		sound_player.pitch_scale = lerpf(
			sound_player.pitch_scale, 1 + (0.007 * (PLInstance.get_pl().get_bpm() - 60)), 
			delta * 3.2)
		
		trauma.set_shader_parameter(
			"blur_amount", 
			lerpf(
				trauma.get_shader_parameter("blur_amount"), 0 + (0.06 * (PLInstance.get_pl().get_bpm() - 60.0)), 
				delta * 2.25))
		
		Music.volume_db = lerpf(
			Music.volume_db, 
			Music.get_bgm_volume() - (0.225 * (PLInstance.get_pl().get_bpm() - 60)), 
			delta * 3.2)	
		Ambience.volume_db = lerpf(
			Music.volume_db, 
			Music.get_bgm_volume() - (0.225 * (PLInstance.get_pl().get_bpm() - 60)), 
			delta * 3.2)

		Game.Audio.adjust_bus_effect( # --- distortion
			"Distorted", 0, 
			"drive", (0.0025 * (PLInstance.get_pl().get_bpm() - 60)))
		Game.Audio.adjust_bus_effect( # --- lowpass
			"Distorted", 1, 
			"cutoff_hz", (clamp(16000 - 150 * (PLInstance.get_pl().get_bpm() - 60), 5000, 16000)))

func set_active(_active: bool = true) -> void:
	if !_active:
		sound_player.volume_db = -50
		sound_player.pitch_scale = 1
		trauma.set_shader_parameter("blur_amount", 0)
	
	sound_player.muted = !_active
	Game.Audio.set_effect_active("Music", 0, _active)
	Game.Audio.set_effect_active("Music", 1, _active)
	
	super(_active)

			
