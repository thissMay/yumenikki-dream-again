class_name Dialogue
extends MessageDisplay

var next_button: GUIPanelButton

func _additional() -> void:
	if next_button == null:
		next_button = GUIPanelButton.new()
		next_button.text = "Next."
		next_button.button.pressed.connect(
			func(): GameManager.message_display_manager.proceed_current_message_display())
		buttons_container.add_child(next_button)

func close() -> void: 
	if next_button != null: next_button.queue_free()
	super()
