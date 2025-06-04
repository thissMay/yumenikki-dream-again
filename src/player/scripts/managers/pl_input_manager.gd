extends SBComponent

var input_controller := InputController.new()
var nav_controller := NavigationController.new()
var current_controller: SentientController

func _setup(_sentient: SentientBase) -> void:
	super(_sentient)
	current_controller = input_controller

func _update(delta: float) -> void: 
	current_controller.update(delta)
