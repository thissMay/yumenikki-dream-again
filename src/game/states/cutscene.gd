extends State

func enter_state() -> void: 
	GameManager.set_cinematic_bars(true)


func exit_state() -> void: 
	GameManager.set_cinematic_bars(false)
