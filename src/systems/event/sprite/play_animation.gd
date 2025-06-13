extends Event

@export var animation_player: AnimationPlayer
@export var animation_library: String
@export var animation_name: String

@export var emit_at_finish: bool = false

func _execute() -> void:
	if animation_player.has_animation(str(animation_library, "/", animation_name)):
		animation_player.play(str(animation_library, "/", animation_name))
	
	if animation_player.get_animation(str(animation_library, "/", animation_name)).loop_mode == Animation.LOOP_NONE:
		await animation_player.animation_finished
		if emit_at_finish: super()
