extends State

func enter_state(s = null) -> void:
	GameManager.set_ui_visibility(true)

func input(event: InputEvent, s = null) -> void:
	if event is InputEventKey && Global.input:
		if !Game.is_paused:
			if (Global.input["key_pressed"] == KEY_ESCAPE &&
				Global.input["pressed_once"]):
					GameManager.pause_options(true)
		
		if (Global.input["key_pressed"] == KEY_TAB &&
			Global.input["pressed_once"]): 
				GameManager.set_ui_visibility(!GameManager.ui_parent.visible)
