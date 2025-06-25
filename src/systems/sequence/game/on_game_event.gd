class_name OnGameEvent
extends Sequence

@export var event_id: String
@export var sequence: Sequence
var listener: EventListener

func _ready() -> void: 
	listener = EventListener.new([event_id], false, self)
	if sequence == null: return
	listener.do_on_notify(event_id, sequence._execute)
	super()
