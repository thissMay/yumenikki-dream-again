class_name PLAnimationManager
extends SentientAnimator

# --- setup functions --- 
func _update(_delta: float) -> void:
	super(_delta)

	if sentient.is_moving: 
		animation_player.speed_scale = clamp(.21 * log(sentient.speed / sentient.MAX_SPEED) + 1, 0, INF)
	else: animation_player.speed_scale = 1
