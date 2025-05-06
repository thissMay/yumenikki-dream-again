extends CanvasLayer
const DEFAULT_SHADER: Shader = preload("res://src/shaders/transition/tr_fade.gdshader")

var fade_in_shader: Shader
var fade_out_shader: Shader
var transition_instance: ColorRect

var fade_tween: Tween

enum fade_type {FADE_IN, FADE_OUT}

func _ready() -> void:
	transition_instance = get_node("transition_instance")
	transition_instance.mouse_filter = Control.MOUSE_FILTER_IGNORE
	transition_instance.material = ShaderMaterial.new()
	
	self.layer = 99
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	
	fade_in_shader = DEFAULT_SHADER
	fade_out_shader = DEFAULT_SHADER
	transition_instance.size = Vector2(Game.main_viewport.size)
	
	request_transition(fade_type.FADE_OUT)

func fade_in(speed: int = 1) -> void: 
	if fade_tween != null: fade_tween.kill()
	fade_tween = transition_instance.create_tween()
	transition_instance.material.shader = fade_in_shader
	
	fade_tween.tween_method(
		func(p: float):
			transition_instance.material.set_shader_parameter("progress", p),
		0 as float, 
		1 as float, 
		1 * speed
		)
		
	await fade_tween.finished
	reset_fade_shaders()
func fade_out(speed: int = 1) -> void: 
	if fade_tween != null: fade_tween.kill()
	fade_tween = transition_instance.create_tween()
	transition_instance.material.shader = fade_out_shader
		
	fade_tween.tween_method(
	func(p: float):
		transition_instance.material.set_shader_parameter("progress", p),
		1 as float, 
		0 as float, 
		1 * speed
		)
		
	await fade_tween.finished

func request_transition(_fade_type: fade_type, color: Color = Color.BLACK) -> void:
	transition_instance.color = color
		
	match _fade_type:
		fade_type.FADE_IN: await fade_in()
		fade_type.FADE_OUT: await fade_out()

func set_fade_out_shader(_shader: Shader) -> void: fade_out_shader = _shader
func set_fade_in_shader(_shader: Shader) -> void: fade_in_shader = _shader

func reset_fade_shaders() -> void:
	fade_in_shader = DEFAULT_SHADER
	fade_out_shader = DEFAULT_SHADER
