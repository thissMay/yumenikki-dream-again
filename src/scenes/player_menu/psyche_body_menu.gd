class_name PscyheBodyMenu extends Node

var active: bool = false

@export var toggle: Control
@export var menu: FSM

var invert_on_begin: EventListener
var invert_on_end: EventListener

func _ready() -> void:
	
	invert_on_begin = EventListener.new(["SPECIAL_INVERT_CUTSCENE_BEGIN"], false, self)
	invert_on_end = EventListener.new(["SPECIAL_INVERT_CUTSCENE_END", "SCENE_CHANGE_REQUEST"], false, self)
	
	setup_psychebody_sys()
	menu._setup()

	toggle.pressed.connect(func():
		if toggle.is_toggled: GameManager.EventManager.invoke_event("SPECIAL_INVERT_CUTSCENE_BEGIN")
		else: GameManager.EventManager.invoke_event("SPECIAL_INVERT_CUTSCENE_END"))

func setup_psychebody_sys() -> void:
	invert_on_begin.do_on_notify(
		func(): 
			menu._enter_initial()
			active = true
			menu.visible = true
			GameManager.change_to_state("special_invert_cutscene"))		
	invert_on_end.do_on_notify(
		func(): 
			if active:
				menu.visible = false
				active = false
				toggle.untoggle()
				GameManager.change_to_state("active"))
	
