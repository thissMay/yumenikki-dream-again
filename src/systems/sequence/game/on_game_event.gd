class_name OnGameEvent
extends Sequence

@export var event_id: String
var listener: EventListener

func _ready() -> void: 
	listener = EventListener.new([event_id], false, self)
	listener.do_on_notify(event_id, _execute)
	super()
