class_name PlEquipManager
extends SBComponent

var effect_prefab: PLPhysicalEff = null
var effect_data: PLEffect = null

# ----> equip / de-equip.
func equip(_ef: PLEffect, _pl: Player, _skip_anim: bool = false) -> void:
	if _ef == effect_data:
		await deequip(_pl, false)
		return
	if _ef:
		await deequip(_pl, true, true)
		effect_data = _ef
		if 	( 
			!_ef.player_component_prefab.is_empty() and
			ResourceLoader.exists(_ef.player_component_prefab) and 
			load(_ef.player_component_prefab).can_instantiate() 
			):
				effect_prefab = load(_ef.player_component_prefab).instantiate()
				effect_prefab.name = "effect" + _ef.name
				_pl.add_child(effect_prefab)
				effect_prefab._enter(_pl)

		GameManager.EventManager.invoke_event("PLAYER_EQUIP_SKIP_ANIM", [_skip_anim])
		GameManager.EventManager.invoke_event("PLAYER_EQUIP", [_ef])
		Player.Instance.equipment_pending = _ef
		_ef._apply(_pl)
		
func deequip(_pl: Player, _skip_anim: bool = false, _skip_default: bool = false) -> void:
	if effect_data:
		GameManager.EventManager.invoke_event("PLAYER_EQUIP_SKIP_ANIM", [_skip_anim])
		GameManager.EventManager.invoke_event("PLAYER_DEEQUIP", [effect_data])
		Player.Instance.equipment_pending = null
		
		_pl.components.get_component_by_name("action_manager").cancel_action(_pl.action, _pl, true)

		if effect_prefab != null: 
			effect_prefab._exit(_pl)
			effect_prefab.queue_free()

		effect_data._unapply(_pl)
		effect_data = null
		
		if _skip_default: return
		equip(_pl.DEFAULT_EFFECT, _pl)
func _input_effect(_input: InputEvent, _pl: Player) -> void: 
	if effect_prefab != null: effect_prefab.input(_input, _pl)
	
func _physics_update(_delta: float) -> void:
	if effect_prefab != null: effect_prefab._physics_update(_delta, sentient)
func _update(_delta: float) -> void:
	if effect_prefab != null: effect_prefab._update(_delta, sentient)
	
func _input_pass(event: InputEvent) -> void: 
	_input_effect(event, sentient)
	if (Global.input["key_pressed"] == KEY_F and
		Global.input["held_down"]):
			equip(PLInventory.favourite_effect, sentient)
