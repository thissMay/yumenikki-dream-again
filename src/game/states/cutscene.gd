extends State

@export var dream_fsm: FSM

func enter_state() -> void: 
	GameManager.set_cinematic_bars(true)
	GameManager.set_ui_visibility(false)
	Game.lerp_timescale(0.2)

func exit_state() -> void: 
	GameManager.set_cinematic_bars(false)
	Game.lerp_timescale(0.2)
	if dream_fsm._get_curr_state_name() == "dream": GameManager.set_ui_visibility(true)
