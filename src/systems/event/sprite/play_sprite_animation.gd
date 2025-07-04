extends Event

@export var animator: SpriteSheetFormatterAnimated
@export var animation_backwards: bool = false

func _execute() -> void:
	animator.play(animator.texture, animation_backwards)
	super()
