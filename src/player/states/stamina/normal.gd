extends State

func physics_update(_delta: float, ) -> void: 
	Player.Instance.get_pl().components.get_component_by_name("mental_status").bpm = (
		Player.Instance.get_pl().components.get_component_by_name("mental_status").calculate_bpm())
		
		
