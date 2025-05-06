extends SentientState

func enter_state(s = null) -> void: 
	s.components.get_component_by_name("action_manager").handle_action_enter()
func exit_state(s = null) -> void: 
	s.components.get_component_by_name("action_manager").handle_action_exit()
	
func physics_update(_delta: float, s = null) -> void: 
	s.components.get_component_by_name("action_manager").handle_action_update(_delta)
func input(event: InputEvent, s = null) -> void: 
	s.components.get_component_by_name("action_manager").handle_action_input(event)
