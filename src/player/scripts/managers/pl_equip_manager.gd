class_name PlEquipManager
extends SBComponent

var curr_stats: PlayerStats

const DEFAULT_EFFECT := preload("res://src/player/madotsuki/effects/_none/_none.tres")
@export var effect: PLPhysicalEff


# ----> equip / de-equip.
func equip(_ef: PlayerEffect, _pl: Player, _skip_anim: bool = false) -> void:
	if _pl.effect: deequip(_pl.effect, _pl, true)
	if _ef and _ef != _pl.effect:
		if 	( 
			!_ef.player_component_prefab.is_empty() and
			ResourceLoader.exists(_ef.player_component_prefab) and 
			load(_ef.player_component_prefab).can_instantiate() 
			):
				effect = load(_ef.player_component_prefab).instantiate()
				effect.name = "effect" + _ef.name
				_pl.add_child(effect)
				effect.action = _ef.action
				effect._enter(_pl)

				if _pl.effect: _pl.effect._unapply(_pl)
				_pl.effect = _ef
				
		GameManager.EventManager.invoke_event("PLAYER_EQUIP_SKIP_ANIM", [_skip_anim])
		GameManager.EventManager.invoke_event("PLAYER_EQUIP", [_ef])
		(_pl as Player_YN).effect = _ef
		_ef._apply(_pl)
		_ef._enter(_pl)	
func deequip(_ef: PlayerEffect, _pl: Player, _skip_anim: bool = false) -> void:
	if _ef:
		_pl.components.get_component_by_name("action_manager").cancel_action(
			_pl.action, _pl)
		GameManager.EventManager.invoke_event("PLAYER_DEEQUIP")

		if effect != null: 
			effect._exit(_pl)
			effect.queue_free()

		(_pl as Player_YN).effect = null
		_ef._exit(_pl)
		_ef._unapply(_pl)
		PLInstance.equipment_pending = null
		equip(DEFAULT_EFFECT, _pl, true)

func _input_effect(_input: InputEvent, _pl: Player) -> void: if effect != null: effect.input(_input, _pl)
func _physics_update(_delta: float) -> void:
	if effect != null: effect._physics_update(_delta, sentient)
func _update(_delta: float) -> void:
	if effect != null: effect._update(_delta, sentient)
	
func _input_pass(event: InputEvent) -> void: 
	if event is InputEventKey && Global.input:
		if (Global.input["key_pressed"] == KEY_F and
			Global.input["held_down"]):
				if (sentient as Player_YN).effect == PLInventory.favourite_effect:
					deequip(PLInventory.favourite_effect, (sentient as Player_YN))
					return
					
				else: equip(PLInventory.favourite_effect, sentient)
