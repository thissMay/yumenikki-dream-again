extends PLAction

var animation_path := "emote/pinch"

func _perform(_pl: Player) -> void: 
	super(_pl)
	if Game.scene_manager.get_curr_packed_scene() == load("res://src/levels/_real/real_room_balc/level.tscn"): return
	(_pl as Player_YN).deequip_effect()
	(_pl as Player_YN).force_change_state("action")
	await (_pl as Player_YN).components.get_component_by_name("animation_manager").play_animation(animation_path)
	GameManager.change_scene_to(load("res://src/levels/_real/real_room_balc/level.tscn"))
	
