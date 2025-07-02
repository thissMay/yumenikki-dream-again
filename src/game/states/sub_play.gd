extends State

@export var dream_manager: FSM
@export var dream_manager_setup: bool = false

func enter_state() -> void:
	if !dream_manager_setup:
		dream_manager_setup = true
		dream_manager._setup()

func input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc_menu"):
		if !Game.is_paused: GameManager.pause_options(true)
		
	if Input.is_action_just_pressed("hud_toggle"):
		GameManager.set_ui_visibility(!GameManager.ui_parent.visible)
