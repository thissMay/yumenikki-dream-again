class_name PlEquipManager
extends SBComponent

var curr_stats: PlayerStats

@export var memoriam: PLPhysicalEff
@export var effect: PLPhysicalEff


# ----> equip / de-equip.
func equip(_ef: PlayerEffect, _pl: Player, _skip_anim: bool = false) -> void:
	if _ef:
		GameManager.EventManager.invoke_event("PLAYER_EQUIP")
		if _ef != _pl.effect: deequip(_pl.effect, _pl, true) # --- dequip if 
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
				GameManager.EventManager.invoke_event("PLAYER_EFFECT_EQUIP")

		_ef._apply(_pl)
		_ef._enter(_pl)
		
		if !_skip_anim: _pl.effect_equip_anim.play("effect_equip")

func deequip(_ef: PlayerEffect, _pl: Player, _skip_anim: bool = false) -> void:
	if _ef: 
		GameManager.EventManager.invoke_event("PLAYER_DEEQUIP")

		if effect != null: 
			effect._exit(_pl)
			effect.queue_free()

			
		_ef._exit(_pl)
		_ef._unapply(_pl)
		PLInstance.equipment_pending = null
	
		if !_skip_anim:
			_pl.effect_equip_anim.play("effect_deequip")
			_pl.effect_equip_node.rotation = randf_range(0, PI)


# ----> Update.
func _input_memoriam(_input: InputEvent, _pl: Player) -> void: if memoriam != null: memoriam.input(_input, _pl)
func _input_effect(_input: InputEvent, _pl: Player) -> void: if effect != null: effect.input(_input, _pl)


func _physics_update(_delta: float) -> void:
	if memoriam != null: memoriam._physics_update(_delta, sentient)
	if effect != null: effect._physics_update(_delta, sentient)
func _update(_delta: float) -> void:
	if memoriam != null: memoriam._update(_delta, sentient)
	if effect != null: effect._update(_delta, sentient)
	
	
