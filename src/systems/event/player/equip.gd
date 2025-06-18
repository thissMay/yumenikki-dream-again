class_name PlayerEquipEffect
extends ResourceEvent

var to_equip: PLEffect

func _execute() -> void: 
	if PLInstance.get_pl() != null:
		(PLInstance.get_pl() as Player_YN).equip(to_equip)
