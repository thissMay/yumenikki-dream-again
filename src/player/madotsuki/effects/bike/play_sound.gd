extends PLAction

@export var sound: AudioStream

func _perform(_pl: Player) -> void: 
	super(_pl)
	AudioService.play_sound(sound)
