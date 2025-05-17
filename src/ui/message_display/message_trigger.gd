class_name MessageTrigger
extends ResourceEvent

@export var interruptive: bool = false
@export var messages: Array[MessageData]
@export var options: Array[PromptOption]
@export var sound := preload("res://src/audio/se/se_talk.wav")

func execute() -> void:
	for m in messages:
		match m.message_type:
			m.type.BASE: MessageDisplayManager.open_message_display(
				MessageDisplay.new(), 
				m.message,
				interruptive,
				sound)
			m.type.DIALOGUE: MessageDisplayManager.open_message_display(
				Dialogue.new(), 
				m.message,
				interruptive,
				sound)
			m.type.PROMPT: 
				var prompt := Prompt.new()
				MessageDisplayManager.open_message_display(
					prompt, 
					m.message,
					interruptive,
					sound)
				prompt.add_existing_options(options, true)
		await SignalBus.dialogue_finish
	super()
