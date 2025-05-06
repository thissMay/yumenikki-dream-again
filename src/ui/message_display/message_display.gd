class_name MessageDisplay
extends PanelContainer

const MIN_SIZE_X = 235
const MIN_SIZE_Y = 100

const DEFAULT_PUNCTUATION_WAIT = 0.25
const DEFAULT_LETTER_WAIT = 0.0275

const DEFAULT_FONT := preload("res://fonts/AGGROPIXEL.ttf")

var initial_position: Vector2

var interruptive: bool = false

var container: MarginContainer
var sub_container: VSplitContainer
var text_container: RichTextLabel
var typewriter_timer: Timer

var sound_player: SoundPlayer
var iterate_sound: AudioStreamWAV = preload("res://src/audio/se/se_talk.wav")

var text: String = ""

var buttons_container: Container

var text_color: Color = Color.WHITE
var text_size: int = 5

var can_progress: bool = false

func _ready() -> void:

	container.add_child(sub_container)
	container.add_theme_constant_override("margin_left", 10)
	container.add_theme_constant_override("margin_right", 10)
	container.add_theme_constant_override("margin_top", 10)
	container.add_theme_constant_override("margin_bottom", 10)
	
	sub_container.add_child(text_container)
	sub_container.add_child(buttons_container)
	sub_container.dragger_visibility = SplitContainer.DRAGGER_HIDDEN_COLLAPSED 
	
	buttons_container.add_theme_constant_override("separation", 10)
	
	text_container.fit_content = true
	text_container.bbcode_enabled = true
	text_container.clip_contents = false
	text_container.scroll_active = false
	
	sub_container.split_offset = 150
	
func _enter_tree() -> void:
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	self.custom_minimum_size = Vector2(MIN_SIZE_X, MIN_SIZE_Y)
	self.name = "message_display"
	self.theme = preload("res://src/global_theme_3.tres")
	
	container = MarginContainer.new()
	sub_container = VSplitContainer.new()
	
	sound_player = SoundPlayer.new()
	
	typewriter_timer = Timer.new()
	text_container = RichTextLabel.new()
	buttons_container = VBoxContainer.new()
	
	self.add_child(container)
	self.add_child(typewriter_timer)
	self.add_child(sound_player)
	
	container.mouse_filter = Control.MOUSE_FILTER_IGNORE	

func _additional() -> void: 
	typewriter_timer.wait_time = 1 + text.length() / 1000
	typewriter_timer.start()
	await typewriter_timer.timeout
	GameManager.message_display_manager.proceed_current_message_display()

func open(
		_position: Vector2,
		_font_size: int = text_size,
		_interruptive: bool = false,
		) -> void:
		interruptive = _interruptive
		initial_position = _position
		self.position = initial_position - self.size / 2
		
		open_animation()
		typewriter_timer.one_shot = true
		typewriter_timer.autostart = false
		
		text_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
		text_container.fit_content = true
		
		text_container.add_theme_font_size_override("normal_font_size", _font_size)
		text_container.add_theme_font_size_override("bold_font_size", _font_size)
		text_container.add_theme_font_size_override("italics_font_size", _font_size)
		text_container.add_theme_font_size_override("bold_italics_font_size", _font_size)
		text_container.add_theme_font_size_override("mono_font_size", _font_size)
		
		text_container.add_theme_font_override("add_theme_font_override", DEFAULT_FONT)
func close() -> void: 
	await close_animation()
	self.queue_free()

func display_text(
		_text: String, 
		_sound: AudioStreamWAV = load("res://src/audio/se/se_talk.wav"),
		_speed: float = 1,
		append_to_current: bool = false
		) -> void:
			await iterate_text(_text, _sound, _speed, false)
			_additional()

func return_parsed(_text: String, c: int = 0, j: int = c + 1) -> String: 
	var parsed_string: String
	var in_tag: bool
	j = c + 1
	
	for ps in _text.length():
		c = ps
		
		if _text[c] == "[":
			if _text[j] != "/": 
				in_tag = true
				continue
			elif _text[j] != "]": 
				in_tag = true
				continue
		if _text[c] == "]": 
			in_tag = false
			continue
		if !in_tag: 
			parsed_string += _text[ps]
	return parsed_string ## outside of a tag
func return_raw(_text: String, c: int = 0, j: int = c + 1) -> String: 
	return _text

func iterate_text(
		_text: String, 
		_sound: AudioStreamWAV = load("res://src/audio/se/se_talk.wav"),
		_speed: float = 1,
		append_to_current: bool = false) -> String:
			var full_text: String
			can_progress = false
			
			text_container.visible_characters = 0
			text_container.clear()
			text = return_parsed(_text)

			for char in text.length(): 
				text_container.text = _text
				text_container.visible_characters += 1

				match text[char]:
					".", "!", "?", ",", ";", ":" : typewriter_timer.wait_time = DEFAULT_PUNCTUATION_WAIT * _speed
					_: typewriter_timer.wait_time = DEFAULT_LETTER_WAIT * _speed
				sound_player.play_sound(_sound, 0, randf_range(0.9, 1.1))
				
				full_text += (text[char])
				typewriter_timer.start()
				await typewriter_timer.timeout
				
			can_progress = true
			return full_text 

func open_animation() -> void: 
	var open_tween := self.create_tween()
	open_tween.set_parallel(true)
	open_tween.set_ease(Tween.EASE_OUT)
	open_tween.set_trans(Tween.TRANS_EXPO)
	
	position.y += 50
	modulate.a = 0
	
	open_tween.tween_property(self, "position:y", initial_position.y, 1)
	open_tween.tween_property(self, "modulate:a", 1, 1)
	
	await open_tween.finished
func close_animation() -> void: 
	var close_tween := self.create_tween()
	close_tween.set_parallel(true)
	close_tween.set_ease(Tween.EASE_OUT)
	close_tween.set_trans(Tween.TRANS_EXPO)
	
	close_tween.tween_property(self, "position:y", position.y + 50, 1)
	close_tween.tween_property(self, "modulate:a", 0, 1)
	
	await close_tween.finished
