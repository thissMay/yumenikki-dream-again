extends Event

func _execute(): 
	Game.quit()
	finished.emit()
