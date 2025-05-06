extends State
	
var old_timescale: float
@export var pause_bgm: BGM


func enter_state(s = null) -> void: 
	old_timescale = Game.get_real_timescale()
	pause_bgm.play_music()
	
	Game.lerp_timescale(0.5)
	GameManager.set_cinematic_bars(true)

func exit_state(s = null) -> void: 	
	Music.play_music_dict(Music.prev_music)

	Game.lerp_timescale(old_timescale)
	GameManager.set_cinematic_bars(false)
