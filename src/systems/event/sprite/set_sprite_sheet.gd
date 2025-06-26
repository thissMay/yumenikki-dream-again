extends Event

@export var animator: SpriteSheetFormatterAnimated
@export var sprite_sheet: Texture2D

func _execute() -> void:
	animator.set_sprite(sprite_sheet)
	super()
