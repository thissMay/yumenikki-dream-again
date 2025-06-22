extends Event

@export var animator: SentientAnimator

func _execute() -> void:
	animator.stop()
	super()
