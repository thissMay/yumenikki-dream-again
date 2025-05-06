class_name BGMClip
extends Resource

@export var stream: AudioStreamOggVorbis
@export_range(-80, 24, .5) var vol: float = 0
@export_range(0.1 , 2, .01) var pitch: float = 1

@export var abrupt_ease: bool = false

func _init(music_stream: AudioStreamOggVorbis = null) -> void: stream = music_stream
