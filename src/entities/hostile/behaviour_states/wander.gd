extends SentientHFSM

@export var min_wait_time: float = 1
@export var max_wait_time: float = 3

@export var wander_radius: float = 25
var direction: Vector2i = Vector2i(1, 1)


# heres how it should work.
# 	1. first it waits for the duration of idle_wait_time
#	2. once the timer ends, it sets a new location and a new wait time.
#	3. the entity moves if its not at the target.
#	4. once it reaches the destination, restarts the timer.

func enter_state() -> void: 
	_change_to_state_or_fsm("wander_idle")
	
	(sentient as NavSentient).nav_agent.target_desired_distance = 10
	(sentient as NavSentient).nav_agent.set_navigation_layer_value(2, true)
	(sentient as NavSentient).nav_agent.set_navigation_layer_value(3, false)
	super()
func exit_state() -> void: 
	super()
