extends SentientState

@export var stance_fsm: SentientFSM
@export var hesitance_timer: Timer
@export_range(0.2, 10, 0.2) var hesitance_wait_time: float

func _ready() -> void:
	hesitance_timer.autostart = false

func enter_state() -> void: 
	hesitance_timer.wait_time = 1
	hesitance_timer.one_shot = false
	hesitance_timer.timeout.connect(func():
		
		hesitance_wait_time = randf_range(0.2, 10)
		hesitance_timer.wait_time = hesitance_wait_time)
		
	hesitance_timer.start()
	
func exit_state() -> void: 
	hesitance_timer.stop()
