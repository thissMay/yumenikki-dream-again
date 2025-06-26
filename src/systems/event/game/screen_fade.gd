extends Event

@export var fade_type: ScreenTransition.fade_type
@export var fade_shader: ShaderMaterial = null
@export var fade_speed: float = 1
@export var fade_colour: Color = Color.BLACK

func _execute() -> void:
	await ScreenTransition.request_transition(
		fade_type, 
		fade_colour, 
		fade_speed, 
		fade_shader)
	super()
