extends PLAction

var animation_path := "emote/hand_teleport"

func _perform(_pl: Player) -> void:
	if Game.scene_manager.get_curr_packed_scene() == load("res://src/levels/_dream/nexus/level.tscn"): return
	print(Game.scene_manager.get_curr_packed_scene())
	(_pl as Player_YN).force_change_state("action")
	
func _enter(_pl: Player) -> void:
	await (_pl as Player_YN).components.get_component_by_name("animation_manager").play_animation(animation_path)
	GameManager.EventManager.invoke_event("PLAYER_DOOR_USED", ["medamaude"])
	GameManager.change_scene_to(load("res://src/levels/_dream/nexus/level.tscn"))
