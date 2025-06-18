class_name PromptOptionButton
extends GUIPanelButton

@export var sequence_caller: SequenceCaller

var option_id: int
var option_name: String

static func _new(_name, _id, _icon) -> PromptOptionButton:
	var option_button := PromptOptionButton.new()
	
	option_button.option_name = _name
	option_button.option_id = _id
	option_button.icon = _icon
	
	return option_button
func _ready() -> void:
	super()
	self.name = "prompt_option_button"
	self.text = option_name

func _press_action() -> void:
	if sequence_caller: 
		sequence_caller.execute()
