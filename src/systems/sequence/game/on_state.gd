extends Sequence

enum MODE {ENTER, EXIT, BOTH}
var state: State
@export var emit_mode: MODE

func _ready() -> void:
	order = get_children()
	state = get_parent()
	
	if state != null and state is State:
		match emit_mode:
			MODE.ENTER: state.entered.connect(_execute)
			MODE.EXIT: state.exited.connect(_execute)
			_:
				state.entered.connect(_execute)
				state.exited.connect(_execute)
				
	process_mode = Node.PROCESS_MODE_DISABLED	
