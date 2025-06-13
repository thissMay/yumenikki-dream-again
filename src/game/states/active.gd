extends State

@export var active_exclusive_cr: ComponentReceiver

func enter_state() -> void:
	active_exclusive_cr.set_bypass(false)
	GameManager.set_ui_visibility(true)
	
func exit_state() -> void:
	active_exclusive_cr.set_bypass(false)

func input(event: InputEvent, ) -> void:
	if event is InputEventKey && Global.input:
		if !Game.is_paused:
			if (Global.input["key_pressed"] == KEY_ESCAPE &&
				Global.input["pressed_once"]):
					GameManager.pause_options(true)
		
		if (Global.input["key_pressed"] == KEY_TAB &&
			Global.input["pressed_once"]): 
				GameManager.set_ui_visibility(!GameManager.ui_parent.visible)
