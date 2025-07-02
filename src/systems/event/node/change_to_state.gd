extends Event

@export var new_state: String
@export var fsm: FSM

func _execute() -> void:
	if fsm == null: 
		super()
		return
		
	fsm._change_to_state(new_state)
	super()
