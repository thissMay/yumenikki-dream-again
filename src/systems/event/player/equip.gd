class_name PlayerEquipEffect
extends ResourceEvent

var to_equip: PLEffect

func _execute() -> void: 
	if Player.Instance.get_pl() != null:
		(Player.Instance.get_pl() as Player_YN).equip(to_equip)
