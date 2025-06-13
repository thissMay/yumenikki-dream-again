extends SentientState

@export var stance_fsm: SentientFSM
@export var aggression_component: SBAggression
var target: SentientBase

func enter_state() -> void:
	if aggression_component.emits_chase_sequence:
		GameManager.EventManager.invoke_event("CHASE_ACTIVE")
		
	(sentient as NavSentient).nav_agent.set_navigation_layer_value(2, false)
	(sentient as NavSentient).nav_agent.set_navigation_layer_value(3, true)
	
	(sentient as NavSentient).nav_agent.target_desired_distance = 20.75
	sentient.look_at_dir((sentient as NavSentient).nav_agent.get_next_path_position() - sentient.global_position)
	super()

func exit_state() -> void:
	if aggression_component.emits_chase_sequence:
		GameManager.EventManager.invoke_event("CHASE_FINISH")

func physics_update(_delta: float) -> void: 
	if (sentient as NavSentient).nav_agent.is_target_reachable():
		
		sentient.handle_velocity((sentient as NavSentient).nav_agent.get_next_path_position() - sentient.global_position, 2)
		sentient.look_at_dir((sentient as NavSentient).nav_agent.get_next_path_position() - sentient.global_position)
		update_chase_point()
	
	else:
		stance_fsm._change_to_state("idle")
		update_chase_point()

func update(_delta: float) -> void:
	if aggression_component.suspicion <= 50:
		aggression_component.suspicion = 20
		fsm._change_to_state("observe")

func update_chase_point() -> void: 
	sentient.nav_agent.target_position = target.global_position
