extends SentientState

@export var idle_timer: Timer
@export var repath_timer: Timer
var wander_radius: float
var wander_vector: Vector2
var direction: Vector2i = Vector2i(1, 1)

func _setup() -> void:
	wander_radius = fsm.wander_radius
	
	if idle_timer == null or repath_timer == null:
		assert(idle_timer == null or repath_timer == null, "NavSentient, Wander State :: Idle Timer not found...")
		return
	idle_timer.autostart = false
	idle_timer.one_shot = true
	idle_timer.timeout.connect(func():
		fsm._change_to_state_or_fsm("wander_move"))
	
	repath_timer.autostart = false
	repath_timer.one_shot = false
	repath_timer.timeout.connect(func(): update_random_wander_point())
	repath_timer.wait_time = 2
	
func enter_state() -> void:
	update_random_wander_point()
	sentient.velocity = Vector2.ZERO
	idle_timer.wait_time = randf_range(fsm.min_wait_time, fsm.max_wait_time)
	
	idle_timer.start()
	repath_timer.start()

func exit_state() -> void:
	idle_timer.stop()
	repath_timer.stop()
	
func update_random_wander_point() -> void: 
	direction = Vector2i(sign(randi_range(-1, 1)), sign(randi_range(-1, 1)))
	wander_vector = sentient.position + Vector2(
		sign(direction.x) * ((sentient.nav_agent.target_desired_distance * 1.1) + wander_radius), 
		sign(direction.y) * ((sentient.nav_agent.target_desired_distance * 1.1) + wander_radius))
	sentient.nav_agent.target_position = wander_vector
