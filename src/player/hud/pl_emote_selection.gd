class_name PLEmoteSelection
extends Control

static var instance

var emote_1: GUIPanelButton
var emote_2: GUIPanelButton

func _ready() -> void:
	instance = self
	
	emote_1 = $emote_1
	emote_2 = $emote_2
	
	for emote_buttons in self.get_children() as Array[GUIPanelButton]:
		emote_buttons.pressed.connect(func(): 
			_show_selection(false)
			PLInstance.get_pl().perform_emote(emote_buttons.unique_data)
			)

func _show_selection(_sh: bool) -> void:
		self.visible =  _sh
func _is_visible() -> bool: return self.visible
