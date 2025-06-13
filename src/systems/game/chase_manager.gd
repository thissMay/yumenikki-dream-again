extends Component

var chase_listener: EventListener

func _setup() -> void:
	chase_listener = EventListener.new(["CHASE_ACTIVE", "CHASE_FINISH"], false, self)
	
	chase_listener.do_on_notify(
		"CHASE_ACTIVE", 
		func():Music.play_sound(preload("res://src/audio/bgm/chase.mp3")))
	
	chase_listener.do_on_notify(
		"CHASE_FINISH", 
		func(): Music.play_sound(
			Music.prev_music["stream"], 
			Music.prev_music["volume"], 
			Music.prev_music["pitch"], 
			Music.prev_music["carry_over"]))
