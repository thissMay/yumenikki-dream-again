extends Event

@export var seconds: float = 1

func _execute() -> void:
	await Game.main_tree.create_timer(seconds, true, true, true).timeout
	super()
