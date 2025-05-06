extends PlayerEmote

func _perform(_pl: Player) -> void:
	(_pl as Player_YN).force_change_state("action")
	
func _enter(_pl: Player) -> void:
	(_pl as Player_YN).animation_manager.play_animation(get_enter_anim_path())
	await (_pl as Player_YN).animation_manager.animation_player.animation_finished
	GameManager.change_scene_to(load("res://src/levels/dream/sane/nexus/level.tscn"))
	(_pl as Player_YN).force_change_state("idle")
	
func _exit(_pl: Player) -> void: pass
func _input(_pl: Player, _input: InputEvent) -> void: pass
