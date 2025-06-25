extends PLAction

func _perform(_pl: Player) -> void: 
	super(_pl)
	if Game.scene_manager.get_curr_packed_scene() == load("res://src/levels/_real/real_room_balc/level.tscn"): return
	
