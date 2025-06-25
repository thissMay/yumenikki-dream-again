@tool
extends EditorPlugin

enum Anchors {
	BOTTOM_LEFT,
	BOTTOM_RIGHT,
	TOP_LEFT,
	TOP_RIGHT
}

var anchors: Array = []
var region_selected: AreaRegion
var dragged_anchor

func _enter_tree() -> void: pass
func _exit_tree() -> void: pass


func _handles(object: Object) -> bool:
	return object is AreaRegion

func _edit(object: Object) -> void:
	region_selected = (object as AreaRegion)
	

	
func _forward_canvas_gui_input(event: InputEvent) -> bool:
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		if event is InputEventMouseButton and (event as InputEventMouseButton).button_index == MOUSE_BUTTON_LEFT:
			for anchor in anchors:
				if !anchor['rect'].has_point(event.position): continue
				dragged_anchor = anchor
				return true
			
				
	return false
	
func _forward_canvas_draw_over_viewport(viewport_control: Control) -> void:
	anchors = []
	
	var pos = region_selected.position
	var half_size = region_selected.rect.shape.size / 2
	
	var anchor_positions := {
		Anchors.BOTTOM_LEFT: pos + Vector2(-1 * half_size.x, half_size.y),
		Anchors.BOTTOM_RIGHT: pos + half_size,
		Anchors.TOP_LEFT: pos - half_size,
		Anchors.TOP_RIGHT: pos + Vector2(half_size.x, -1 * half_size.y) 
	}

	var CIRCLE_RADIUS = 8
	var anchor_size := Vector2(CIRCLE_RADIUS * 2, CIRCLE_RADIUS * 2)
	
	for coords in anchor_positions.values():
		var anchor_centre: Vector2 = region_selected.get_viewport_transform() * region_selected.get_canvas_transform() * coords
		var new_anchor := {
			'position' : anchor_centre,
			'rect' : Rect2(anchor_centre - anchor_size, anchor_size / 2)
		}
		anchors.append(new_anchor)
	
	for anchor in anchors:
		viewport_control.draw_circle(anchor['position'], CIRCLE_RADIUS, Color.RED)

func drag_to(event_position: Vector2) -> void: 
	var viewport_inverse_transform := region_selected.get_viewport().global_canvas_transform.affine_inverse()
	var viewport_position := viewport_inverse_transform.basis_xform(event_position)
	var global_transform_inverse := region_selected.get_global_transform().affine_inverse()
	
	var target_position := global_transform_inverse.basis_xform(viewport_position).round()
	var target_size := target_position.abs() * 2
