extends Event

@export var animator: SentientAnimator
@export var animation_path: String
@export var animation_speed: float = 1
@export var animation_backwards: bool = false

func _execute() -> void:
	await animator.play_animation(animation_path, animation_speed, animation_backwards)
	super()
