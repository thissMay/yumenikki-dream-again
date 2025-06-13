class_name BGM extends Node

const ZEROVOLUME = -50 # the volume dB where the audio player is silent.
enum MUSIC_BUS {MUSIC, AMBIENCE}

@export var music_bus: MUSIC_BUS
@export var save_as_previous: bool = false

@export_group("Music Properties")
	
@export var stream: AudioStream
@export_range(0, 1, .1) var vol: float = 1
@export_range(0.1 , 2, .01) var pitch: float = 1
@export var autoplay: bool = true

## -------- AUDIO CLIP CONTROL (E.G LOOP or smth) -------- ##	
func _ready() -> void:	
	if autoplay: play_music()

func play_music() -> void:
	match music_bus:
		MUSIC_BUS.MUSIC: Music.play_sound(stream, vol, pitch)
		MUSIC_BUS.AMBIENCE: Ambience.play_sound(stream, vol, pitch) 

## -------- AUDIO CONTROL (E.G AUDIO FADE) -------- ##
