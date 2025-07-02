extends Event
@export var interactable: Interactable
@export var can_interact: bool = false

func _execute() -> void:
	interactable.can_interact = can_interact
	super()
