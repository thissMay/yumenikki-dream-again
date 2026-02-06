extends PLEffect


# so this one extends from the PLEffect resource.

func _apply(_pl: Player) -> void: 
	_pl.components.get_component_by_name("sprite_manager").set_dynamic_rot_multi(0.45)
func _unapply(_pl: Player) -> void:
	_pl.components.get_component_by_name("sprite_manager").set_dynamic_rot_multi(
		SentientAnimator.DEFAULT_DYNAMIC_ROT_MULTI)
