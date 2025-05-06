class_name PlayerEquipEffect
extends ResourceCommand

var to_equip: PlayerEffect

func _execute() -> void: 
	if PLInstance.get_pl() != null:
		(PLInstance.get_pl() as Player_YN).equip(to_equip)
