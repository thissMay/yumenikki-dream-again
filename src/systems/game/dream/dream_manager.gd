extends FSM

@onready var scene_changed_listener := EventListener.new(["SCENE_CHANGE_SUCCESS"], false, self)

func _setup() -> void:
	super()
	scene_changed_listener.do_on_notify(
		"SCENE_CHANGE_SUCCESS", 
		func(): print(GameManager.EventManager.get_event_param("SCENE_CHANGE_SUCCESS")[0]))
