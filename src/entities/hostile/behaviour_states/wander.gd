extends SentientState

@export var stance_fsm: SentientFSM
@export var idle_timer: Timer
@export_range(0.2, 10, 0.2) var idle_wait_time: float = 5

func _ready() -> void:
	
	if idle_timer == null:
		assert(idle_timer == null, "NavSentient, Wander State :: Idle Timer not found...")
		return
	idle_timer.wait_time = idle_wait_time
	idle_timer.autostart = false
	idle_timer.one_shot = false
	
	idle_timer.timeout.connect(func():
		stance_fsm._change_to_state("idle")
		idle_wait_time = randf_range(0.2, 10)
		idle_timer.wait_time = idle_wait_time)
		

func enter_state() -> void: 
	(sentient as NavSentient).nav_agent.target_position = Vector2.ZERO
	idle_timer.start()

func exit_state() -> void: 
	idle_timer.stop()

func physics_update(_delta: float) -> void: pass
func update(_delta: float) -> void: pass
