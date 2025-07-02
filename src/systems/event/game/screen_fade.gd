extends Event

@export var fade_type: ScreenTransition.fade_type
@export var fade_shader: ShaderMaterial = null
@export var fade_speed: float = 1
@export var fade_colour: Color = Color.BLACK

func _execute() -> void:
	if !wait_til_finished: finished.emit.call_deferred()
	await ScreenTransition.request_transition(
		fade_type, 
		fade_colour, 
		fade_speed, 
		fade_shader)
	
	if wait_til_finished: finished.emit.call_deferred()
