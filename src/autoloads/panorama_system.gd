extends Node

var initial: bool = false
var initial_screen_centre := Vector2()

var screen_centre := Vector2()
var viewport_size := Vector2()
var eqn := Vector2()

var warp_check: bool = false
var panorama_update: EventListener
var total_uv_offset := Vector2()

func setup() -> void:
	panorama_update = EventListener.new(["WORLD_LOOP", "SCENE_CHANGE_SUCCESS"], false, self)
	panorama_update.do_on_notify("WORLD_LOOP", func(): warp_check = true)
	panorama_update.do_on_notify("SCENE_CHANGE_SUCCESS", func(): eqn = Vector2.ZERO)
	
	initial_screen_centre = (
		Game.main_viewport.get_camera_2d().get_screen_center_position()
			if Game.main_viewport.get_camera_2d()
			else Vector2.ZERO)
			
	viewport_size = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)
			
func update(_delta: float) -> void:
		if !initial: initial_screen_centre = (
			Game.main_viewport.get_camera_2d().get_screen_center_position()
			if Game.main_viewport.get_camera_2d()
			else Vector2.ZERO)

		initial = true
						
		screen_centre = (
			Game.main_viewport.get_camera_2d().get_screen_center_position()
			if Game.main_viewport.get_camera_2d()
			else Vector2.ZERO) - initial_screen_centre
		
		if !warp_check and CameraHolder.instance != null:
			eqn += (
				CameraHolder.instance.vel) / Vector2(Game.get_viewport_height(), Game.get_viewport_width()
				)
			RenderingServer.global_shader_parameter_set(
			"uv_offset",  eqn)
		elif warp_check: warp_check = false
		

			
