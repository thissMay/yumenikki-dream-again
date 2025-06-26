extends Event

@export var animator: AnimationPlayer
@export var animation_path: String
@export var animation_speed: float = 1
@export var animation_backwards: bool = false
@export var wait_til_finished: bool = true

func _execute() -> void:
	
	if !wait_til_finished: super()
	if !animator.has_animation(animation_path): 
		return
		
	
	animator.play(
		animation_path, -1,
		animation_speed, animation_backwards)
	await animator.animation_finished
	if wait_til_finished: super()
