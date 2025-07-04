extends CanvasLayer
var DEFAULT_SHADER: Shader = preload("res://src/shaders/transition/tr_fade.gdshader")

var fade_in_shader: ShaderMaterial
var fade_out_shader: ShaderMaterial
var default_shader: ShaderMaterial
var transition_instance: ColorRect

var fade_tween: Tween

enum fade_type {FADE_IN, FADE_OUT}

func _ready() -> void:
	transition_instance = get_node("transition_instance")
	transition_instance.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	self.layer = 99
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	
	fade_in_shader = ShaderMaterial.new()
	fade_out_shader = ShaderMaterial.new()
	default_shader = ShaderMaterial.new()
	
	default_shader.shader = DEFAULT_SHADER
	fade_in_shader = default_shader
	fade_out_shader = default_shader
	# im so confused
	
	transition_instance.size = Vector2(Game.main_viewport.size)
	
	request_transition(fade_type.FADE_OUT)

func fade_in(speed: int = 1, _shader: ShaderMaterial = fade_in_shader) -> void: 
	if fade_tween != null: fade_tween.kill()
	fade_tween = transition_instance.create_tween()
	
	if _shader == null: transition_instance.material = default_shader
	else: transition_instance.material = _shader
	
	fade_tween.tween_method(
		func(p: float):
			transition_instance.material.set_shader_parameter("progress", p),
			0 as float, 
			1 as float, 
			1 * speed)
		
	await fade_tween.finished
	reset_fade_shaders()
func fade_out(speed: int = 1, _shader: ShaderMaterial = fade_out_shader) -> void: 
	if fade_tween != null: fade_tween.kill()
	fade_tween = transition_instance.create_tween()
	
	if _shader == null: transition_instance.material = default_shader
	else: transition_instance.material = _shader
	transition_instance.material.set_shader_parameter("progress", 1)
	
	fade_tween.tween_method(
	func(p: float):
		transition_instance.material.set_shader_parameter("progress", p),
		1 as float, 
		0 as float, 
		1 * speed)
		
	await fade_tween.finished

func request_transition(
	_fade_type: fade_type, 
	_colour: Color = Color.BLACK,
	_speed: float = 1,
	_custom_shader: ShaderMaterial = null) -> void:
	transition_instance.color = _colour
		
	match _fade_type:
		fade_type.FADE_IN: await fade_in(_speed, _custom_shader)
		fade_type.FADE_OUT: await fade_out(_speed, _custom_shader)

func set_fade_out_shader(_shader: ShaderMaterial) -> void: 
	if _shader.shader == null: 
		fade_out_shader.shader = DEFAULT_SHADER
		transition_instance.material = fade_out_shader
		return
		
	fade_out_shader = _shader
	transition_instance.material = _shader
func set_fade_in_shader(_shader: ShaderMaterial) -> void:
	if _shader.shader == null: 
		fade_in_shader.shader = DEFAULT_SHADER
		transition_instance.material = fade_in_shader
		return
		
	fade_in_shader = _shader
	transition_instance.material = _shader

func reset_fade_shaders() -> void:
	fade_in_shader.shader = DEFAULT_SHADER
	fade_out_shader.shader = DEFAULT_SHADER
