@tool
extends EditorPlugin

var current_rect_obj

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	pass


func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	pass

func _edit(_object: Object) -> void: 
	print(_object)
	
func _forward_canvas_draw_over_viewport(viewport_control: Control) -> void:
	viewport_control.draw_circle(Vector2(1920 / 2, 1080 / 2), 500, Color.CYAN)
	viewport_control.draw_circle((current_rect_obj as OnScreenNotifier).rect.position, 3, Color.WHITE)
	viewport_control.draw_circle((current_rect_obj as OnScreenNotifier).rect.end, 3, Color.WHITE)
	
