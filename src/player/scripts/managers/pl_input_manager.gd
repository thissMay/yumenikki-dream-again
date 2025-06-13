class_name PLInput
extends SBComponent

var input_controller := InputController.new()
var nav_controller := NavigationController.new()
var current_controller: SentientController

var keybinds: SentientController.SentientKeybind

func _setup(_sentient: SentientBase) -> void:
	super(_sentient)
	keybinds = SentientController.SentientKeybind.new()
	current_controller = input_controller

func _update(delta: float) -> void: 
	current_controller.update(delta)

func key_pressed(_input: Key) -> bool: 
	return _input 
	
func _input_pass(event: InputEvent) -> void:
	if event is InputEventKey:
		key_pressed(event.keycode)
