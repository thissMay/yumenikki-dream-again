extends SentientState

@export var path_update_timer: Timer
@export var stance_fsm: SentientFSM
var target: SentientBase

func enter_state() -> void: 
	if target == null: return
	(sentient as NavSentient).nav_agent.target_desired_distance = 32.5
	(sentient as NavSentient).nav_agent.target_position = target.global_position
	super()

func physics_update(_delta: float) -> void: 
	if target == null: return
	(sentient as NavSentient).nav_agent.target_position = target.global_position
	
	if (sentient as NavSentient).nav_agent.is_navigation_finished() or (sentient as NavSentient).nav_agent.is_target_reached():
		if stance_fsm == null: return
		stance_fsm._change_to_state("idle")
	else:
		(sentient as NavSentient).handle_velocity((sentient as NavSentient).nav_agent.get_next_path_position() - sentient.global_position)
		sentient.look_at_dir((sentient as NavSentient).nav_agent.get_next_path_position() - sentient.global_position)
