extends SentientState

func physics_update(_delta: float) -> void: 
	if (!(sentient as NavSentient).nav_agent.is_target_reached() and 
		(sentient as NavSentient).nav_agent.is_target_reachable()):
			
		sentient.handle_velocity(
			(sentient as NavSentient).nav_agent.get_next_path_position() - sentient.global_position)
		sentient.look_at_dir(
			(sentient as NavSentient).nav_agent.get_next_path_position() - sentient.global_position)
	
	else:
		(fsm as SentientHFSM)._change_to_state_or_fsm("wander_idle")
