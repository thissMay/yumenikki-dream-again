class_name Prompt
extends MessageDisplay

@export var options: Array[PromptOption] = []


func _additional() -> void: 
	assert(options != [], "Prompt must have AT LEAST one option.")

func add_new_option(
	_option_name: String,
	_id: int) -> void:
		var option = PromptOption.new()
		option.option_name = _option_name
		option.option_id = _id
		
		options.append(option)
		add_new_option_button(option.option_name, option.option_id, option.events)
func add_existing_options(_options: Array[PromptOption], override: bool = false) -> void:
	if !override: options += _options
	else: 
		options.clear()
		options = _options
	
	for option in _options:
		add_new_option_button(
			option.option_name, 
			option.option_id, 
			option.icon,
			option.events)
	
func add_new_option_button(
	_option_name: String,
	_id: int,
	_icon: Texture2D = null,
	_sequence: Sequence = null) -> void:
		var option_button = PromptOptionButton._new(_option_name, _id, _icon)
		#option_button.event_trigger = EventTrigger.new(_events)
		option_button.button.pressed.connect(
			func(): 
				#GameManager.message_display_manager.close_message_display()
				for options in self.buttons_container.get_children(): options.queue_free()
		)
		buttons_container.add_child(option_button)

func clear_options() -> void:
	options.clear()
	for option_buttons in buttons_container.get_children(): 
		option_buttons.queue_free()
func remove_option(_id: int) -> void:
	pass
	#if _id in options.keys(): options[_id].queue_free()	
func get_option(_id: int) -> PromptOption:
	#if _id in options.keys(): return options[_id]
	return
