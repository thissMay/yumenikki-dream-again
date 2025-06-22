extends Event

enum type {MESSAGE, DIALOGUE, PROMPT}

@export var message_type: type
@export_multiline var texts: Array[String]

@export_group("Overrides.")
@export var sound_override: AudioStream = load("res://src/audio/se/se_talk.wav")
@export var font_override: Font
@export var colour_override: Color
@export var speed_override: float = 1
@export var reset_texts: bool = false

func _execute() -> void: 
	var type_to_display: MessageDisplay
	match message_type:
		type.MESSAGE: type_to_display = MessageDisplayManager.instance.message_display
		type.DIALOGUE: type_to_display = MessageDisplayManager.instance.dialogue_display
		type.PROMPT: type_to_display = MessageDisplayManager.instance.prompt_display
		
	MessageDisplayManager.instance.open_message_display(
		type_to_display, 
		texts,
		sound_override,
		speed_override,
		reset_texts)
