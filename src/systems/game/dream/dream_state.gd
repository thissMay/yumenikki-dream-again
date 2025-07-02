extends State

func enter_state() -> void:
	GameManager.set_ui_visibility(true)

func exit_state() -> void:
	GameManager.set_ui_visibility(false)
