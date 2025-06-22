extends SentientState

@export var stance_fsm: SentientFSM
@export var aggression_component: SBAggression
@export var hesitance_timer: Timer

@export var min_wait_time: float = 1
@export var max_wait_time: float = 1.5

@export var hesitance_distance: float = 50

var target: SentientBase
var roll: float = 0

func _setup() -> void:
	if aggression_component == null: return
	hesitance_timer.wait_time = randf_range(min_wait_time, max_wait_time)
	hesitance_timer.autostart = false
	hesitance_timer.one_shot = true

	hesitance_timer.timeout.connect(func():
		stance_fsm._change_to_state("idle")	
		hesitance_timer.wait_time = randf_range(min_wait_time, max_wait_time)
		update_hesitance_observe_point())
		
	(sentient as NavSentient).nav_agent.target_reached.connect(hesitance_timer.start)

func enter_state() -> void:
	roll = randf()
	 		
	target = aggression_component.target
	aggression_component.suspicion_indicator_status.visible = true
	aggression_component.suspicion_indicator_status.progress = 0
	
	(sentient as NavSentient).nav_agent.target_desired_distance = 10
	(sentient as NavSentient).nav_agent.set_navigation_layer_value(2, false)
	(sentient as NavSentient).nav_agent.set_navigation_layer_value(3, true)
	hesitance_timer.start()
	super()
	
func exit_state() -> void: 
	
	aggression_component.suspicion_indicator_status.visible = false
	hesitance_timer.stop()
	super()
	
func update(_delta: float) -> void:
	if aggression_component.suspicion > aggression_component.min_chase_threshold:
		if fsm._has_state("taunt") and roll >= aggression_component.taunt_chance: 
			fsm._change_to_state("taunt")
		
		else: 
			fsm._change_to_state("chase")
			
	if aggression_component.suspicion < 10:
		fsm._change_to_state("wander")
		
func physics_update(_delta: float) -> void: 
	if (!(sentient as NavSentient).nav_agent.is_target_reached() and 
		(sentient as NavSentient).nav_agent.is_target_reachable()):
			
		sentient.handle_velocity((sentient as NavSentient).nav_agent.get_next_path_position() - sentient.global_position)
		sentient.look_at_dir((sentient as NavSentient).nav_agent.get_next_path_position() - sentient.global_position)
	
	else:
		stance_fsm._change_to_state("idle")	
		
	if !(sentient as NavSentient).nav_agent.is_target_reachable():
		update_hesitance_observe_point()


	print(sentient.nav_agent.is_target_reachable())
func update_hesitance_observe_point() -> void: 
	sentient.nav_agent.target_position = target.global_position
