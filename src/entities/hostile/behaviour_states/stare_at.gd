extends SentientState

var target: SentientBase

func physics_update(_delta: float) -> void:
	if target == null: return
	sentient.look_at_dir((target.global_position - sentient.global_position))
