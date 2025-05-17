extends State

func physics_update(_delta: float, s = null) -> void: 
	PLInstance.get_pl().components.get_component_by_name("mental_status").bpm = (
		PLInstance.get_pl().components.get_component_by_name("mental_status").calculate_bpm())
		
		
