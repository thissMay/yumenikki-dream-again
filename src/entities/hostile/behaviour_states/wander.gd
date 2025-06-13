extends SentientState

@export var stance_fsm: SentientFSM
@export var idle_timer: Timer
#@export var path_timer_update: Timer

@export var min_wait_time: float = 1
@export var max_wait_time: float = 3

@export var wander_radius: float = 12

var direction: Vector2i = Vector2i(1, 1)

# heres how it should work.
# 	1. first it waits for the duration of idle_wait_time
#	2. once the timer ends, it sets a new location and a new wait time.
#	3. the entity moves if its not at the target.
#	4. once it reaches the destination, restarts the timer.

func _setup() -> void:
	
	if idle_timer == null:
		assert(idle_timer == null, "NavSentient, Wander State :: Idle Timer not found...")
		return
	idle_timer.wait_time = randf_range(min_wait_time, max_wait_time)
	idle_timer.autostart = false
	idle_timer.one_shot = true
	
	idle_timer.timeout.connect(func():
		#path_timer_update.wait_time = 8
		#path_timer_update.start()
		
		stance_fsm._change_to_state("idle")	
		idle_timer.wait_time = randf_range(min_wait_time, max_wait_time)
		update_random_wander_point())
			
	(sentient as NavSentient).nav_agent.target_reached.connect(func(): idle_timer.start())
		
	#path_timer_update.timeout.connect(func(): 
		#if sentient.is_moving: return
		#update_random_wander_point())

func enter_state() -> void: 
	(sentient as NavSentient).nav_agent.target_desired_distance = 10
	(sentient as NavSentient).nav_agent.set_navigation_layer_value(2, true)
	(sentient as NavSentient).nav_agent.set_navigation_layer_value(3, false)
	idle_timer.start()
	super()
func exit_state() -> void: 
	idle_timer.stop()
	super()

func physics_update(_delta: float) -> void: 
	
	if (!(sentient as NavSentient).nav_agent.is_target_reached() and 
		(sentient as NavSentient).nav_agent.is_target_reachable()):
			
		sentient.handle_velocity(
			(sentient as NavSentient).nav_agent.get_next_path_position() - sentient.global_position)
		sentient.look_at_dir(
			(sentient as NavSentient).nav_agent.get_next_path_position() - sentient.global_position)
	
	else:
		stance_fsm._change_to_state("idle")	
		
	if !(sentient as NavSentient).nav_agent.is_target_reachable():
		update_random_wander_point()

func update_random_wander_point() -> void: 
	direction = Vector2i(sign(randi_range(-1, 1)), sign(randi_range(-1, 1)))
	sentient.nav_agent.target_position = sentient.position + Vector2(
		sign(direction.x) * randf_range(sentient.nav_agent.target_desired_distance * 1.5, wander_radius), 
		sign(direction.y) * randf_range(sentient.nav_agent.target_desired_distance * 1.5, wander_radius))
		
