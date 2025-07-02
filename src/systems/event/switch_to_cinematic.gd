extends Event

@export var switch_to_cinematic: bool = true

func _execute() -> void:
	if switch_to_cinematic: GameManager.set_cinematic_bars(switch_to_cinematic)
	else: GameManager.set_cinematic_bars(false)
	super()
	
