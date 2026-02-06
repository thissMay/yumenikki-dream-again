class_name PanoramaSystem
extends Component

@export var panorama_rect: TextureRect
@export var default_panorama_texture: Texture

const MINIMUM_SIZE := Vector2(480, 270)

var initial_screen_centre	: Vector2
var screen_centre 			: Vector2
var viewport_size 			: Vector2
var eqn 					: Vector2

static var instance: PanoramaSystem

func _setup() -> void:
	instance = self
	panorama_rect.custom_minimum_size 	= MINIMUM_SIZE
	panorama_rect.global_position = Vector2.ZERO
	
	viewport_size = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)
	
func _physics_update(_delta: float) -> void:
	if 	Player.Instance.get_pl() != null and \
		Player.Instance.get_pl().can_process():
		eqn += (Player.Instance.get_pl().get_real_velocity() / 100) / Application.get_viewport_dimens()

	RenderingServer.global_shader_parameter_set("uv_offset",  eqn)

func apply_panorama(_panorama: SubViewport, _pivot: Vector2) -> void:
	eqn = ((Player.Instance.get_pos(true) - _pivot) / Application.get_viewport_dimens())
	panorama_rect.texture 				= _panorama.get_texture()
func remove_panorama() -> void:
	panorama_rect.texture 				= default_panorama_texture
