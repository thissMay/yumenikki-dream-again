extends State
	
var old_timescale: float
@export var bgm: BGM


func enter_state() -> void: 
	GameManager.EventManager.invoke_event("SPECIAL_INVERT_CUTSCENE_BEGIN")
	bgm.play_music()
	
	old_timescale = Game.get_real_timescale()
	
	
	Game.lerp_timescale(0.5)
	GameManager.set_cinematic_bars(true)

func exit_state() -> void: 	
	GameManager.EventManager.invoke_event("SPECIAL_INVERT_CUTSCENE_END")
	Music.play_music_dict(Music.prev_music)

	Game.lerp_timescale(old_timescale)
	GameManager.set_cinematic_bars(false)
