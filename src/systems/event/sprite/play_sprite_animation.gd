extends Event

@export var animator: SpriteSheetFormatterAnimated
@export var animation_backwards: bool = false

func _execute() -> void:
	animator.play(animation_backwards)
	super()
