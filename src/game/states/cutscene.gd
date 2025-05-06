extends State

func enter_state(s = null) -> void: 
	GameManager.set_cinematic_bars(true)


func exit_state(s = null) -> void: 
	GameManager.set_cinematic_bars(false)
