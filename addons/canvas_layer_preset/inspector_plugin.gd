extends EditorInspectorPlugin

func _can_handle(object: Object) -> bool:
	return object is CanvasLayer

func _parse_begin(object: Object) -> void:
	add_custom_control(layer_preset_control())
	
func layer_preset_control() -> Control:
	var target := EditorInterface.get_inspector().get_edited_object() as CanvasLayer
	var preset_selected: String
	
	match target.layer:
		-30: preset_selected = str("Panorama #1 (", target.layer, ")")
		-25: preset_selected = str("Panorama #2 (", target.layer, ")")
		-20: preset_selected = str("Panorama #3 (", target.layer, ")")
		0: preset_selected = str("Zero (", target.layer, ")")
		5: preset_selected = str("Camera (", target.layer, ")")
		10: preset_selected = str("Screen Overlay (", target.layer, ")")
		20: preset_selected = str("Screen Transition (", target.layer, ")") 
		_: preset_selected = str("Other (Custom: ", target.layer, ")") 
	
	var main_container := HSplitContainer.new()
	var preset_label := Label.new()
	var preset_selection := MenuButton.new()
	
	preset_label.text = str("Preset Selected: ", preset_selected)
	
	preset_selection.text = "Preset Selection"
	preset_selection.get_popup().add_item("Panorama #1: -30", 00)
	preset_selection.get_popup().add_item("Panorama #2: -25", 01)
	preset_selection.get_popup().add_item("Panorama #3: -20", 02)
	preset_selection.get_popup().add_item("Zero: 0", 10)
	preset_selection.get_popup().add_item("Camera: +5", 20)
	preset_selection.get_popup().add_item("Screen Overlay: +10", 30)
	preset_selection.get_popup().add_item("Screen UI: +20", 40)
	preset_selection.get_popup().add_item("Transition: +99", 50)
	
	
	var handle_preset_id_selection := func(id: int):
		match id:
			00: 
				target.layer = -30
				target.name = "panorama (bottom_layer)"
			01: 
				target.layer = -25
				target.name = "panorama (middle_layer)"
			02: 
				target.layer = -20
				target.name = "panorama (top_layer)"
			10: 
				target.layer = 0
				target.name = "normal"
			20: 
				target.layer = 5
				target.name = "camera"
			30: 
				target.layer = 10
				target.name = "screen_overlay"
			40: 
				target.layer = 20
				target.name = "ui"
			50: 
				target.layer = 99
				target.name = "transition"

		
	if !preset_selection.get_popup().id_pressed.is_connected(handle_preset_id_selection):
		preset_selection.get_popup().id_pressed.connect(handle_preset_id_selection)

	
	main_container.add_child(preset_label)
	main_container.add_child(preset_selection)
	
	return main_container
