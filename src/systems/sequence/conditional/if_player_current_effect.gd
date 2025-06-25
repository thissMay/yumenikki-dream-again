extends ConditionalSequence
@export var current_effect_is: PLEffect

func _predicate() -> bool:
	return Player.Instance.get_pl().components.get_component_by_name("equip_manager").effect_data == current_effect_is
