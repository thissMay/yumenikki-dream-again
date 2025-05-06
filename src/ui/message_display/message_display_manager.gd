class_name MessageDisplayManager
extends Node

const BASE := preload("res://src/ui/message_display/message_instance.tscn")

var active: MessageDisplay

var message_display: MessageDisplay
var prompt_display: MessageDisplay
var dialogue_display: MessageDisplay

var current_index: int = 0
var texts: Array[String]

func _ready() -> void:
	pass
	#active = MessageDisplay.new()
	#
	#message_display = MessageDisplay.new()
	#prompt_display = Prompt.new()
	#dialogue_display = Dialogue.new()
	#
	#message_display.visible = false
	#prompt_display.visible = false
	#dialogue_display.visible = false
	#
	#self.add_child(active)

func open_message_display(
	_display: MessageDisplay,
	_texts: Array[String], 
	_interruptive: bool = false, 
	_sound: AudioStreamWAV = load("res://src/audio/se/se_talk.wav"),
	_speed: int = 1,
	_reset: bool = true, 
	_pos: Vector2 = Vector2(Game.viewport_width / 2, Game.viewport_length - 110)) -> void: 
		if message_display != null: 
			close_message_display(message_display)
			active = _display
		if _reset: current_index = 0
		
		texts.clear()
		for t in _texts: texts.append(t)
		
		
		active.visible = true

		message_display.open(
			_pos, 
			message_display.text_size, 
			_interruptive,
			)
		message_display.display_text(_texts[current_index], _sound, _speed)
func close_message_display(_display: MessageDisplay) -> void: 
	await _display.close()

func get_current_message_display() -> MessageDisplay: 
	if message_display: return message_display
	return
func proceed_current_message_display() -> void:
	if get_current_message_display().can_progress:
		if current_index < texts.size() - 1:
			current_index += 1
			message_display.display_text(texts[current_index])

		else:
			close_message_display(get_current_message_display())
