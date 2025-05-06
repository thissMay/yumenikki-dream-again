extends SoundPlayer
#func play_sound(
	#sound: AudioStreamWAV,
	#volume: float = 0,
	#pitch: float = 1,
	#forget_after: bool = false) -> void:
		#if ResourceLoader.exists(sound.resource_path):
			#if playing: stop()
			#stream = sound
			#volume_db = volume
			#pitch_scale = pitch
			#play()
