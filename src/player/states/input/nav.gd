extends SentientState
@export var nav_agent: NavigationAgent2D

func update(_delta: float) -> void:
	sentient.input = nav_agent.get_next_path_position() - sentient.global_position
