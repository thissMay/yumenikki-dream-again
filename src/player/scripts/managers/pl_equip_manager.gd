class_name PlEquipManager
extends SBComponent

var curr_stats: PlayerStats

@export var memoriam: PLPhysicalEff
@export var effect: PLPhysicalEff

@onready var effect_equip_anim_end := EventListener.new(["PLAYER_EFFECT_EQUIP_ANIM"], false, self)
@onready var effect_deequip_anim_end := EventListener.new(["PLAYER_EFFECT_DEEQUIP_ANIM"], false, self)

# ----> equip / de-equip.
func equip(_ef: PlayerEffect, _pl: Player, _skip_anim: bool = false) -> void:
	if _ef:
		GameManager.EventManager.invoke_event("PLAYER_PRE_EQUIP")
		match _ef.eff_type:
			PlayerEffect.type.EFFECT: if _ef != _pl.effect: deequip(_pl.effect, _pl, true)
			PlayerEffect.type.MEMORIAM: if _ef != _pl.memoriam: deequip(_pl.memoriam, _pl, true)
		
		effect_equip_anim_end.do_on_notify(
			func():
				# --- if the effect has an exclusive prefab
				if 	( 
					!_ef.player_component_prefab.is_empty() and
					ResourceLoader.exists(_ef.player_component_prefab) and 
					load(_ef.player_component_prefab).can_instantiate() 
					):
						match _ef.eff_type:
							PlayerEffect.type.EFFECT: 
								effect = load(_ef.player_component_prefab).instantiate()
								effect.name = "effect" + _ef.name
								_pl.add_child(effect)
								effect.action = _ef.action
								effect._enter(_pl)
							PlayerEffect.type.MEMORIAM: 
								memoriam = load(_ef.player_component_prefab).instantiate()
								memoriam.name = "memoriam_" + _ef.name
								_pl.add_child(memoriam)
								memoriam.action = _ef.action
								memoriam._enter(_pl)
						
				match _ef.eff_type:
					PlayerEffect.type.EFFECT: 
						if _pl.effect: _pl.effect._unapply(_pl)
						_pl.effect = _ef
						GameManager.EventManager.invoke_event("PLAYER_EFFECT_EQUIP")
					PlayerEffect.type.MEMORIAM: 
						if _pl.memoriam: _pl.memoriam._unapply(_pl)
						_pl.memoriam = _ef
						GameManager.EventManager.invoke_event("PLAYER_MEMORIAM_EQUIP")
				_ef._apply(_pl)
				_ef._enter(_pl)
				) 
		
		if !_skip_anim:
			_pl.effect_equip_anim.play("effect_equip")
			_pl.effect_equip_node.rotation = randf_range(0, PI)
		else: effect_equip_anim_end.on_notify()
func deequip(_ef: PlayerEffect, _pl: Player, _skip_anim: bool = false) -> void:
	if _ef: 
		GameManager.EventManager.invoke_event("PLAYER_PRE_DEEQUIP")
		effect_deequip_anim_end.do_on_notify(
		func(): 
			match _ef.eff_type:
				PlayerEffect.type.EFFECT: 
					GameManager.EventManager.invoke_event("PLAYER_EFFECT_DEEQUIP")
					if effect != null: 
						effect._exit(_pl)
						effect.queue_free()
				PlayerEffect.type.MEMORIAM: 
					GameManager.EventManager.invoke_event("PLAYER_MEMORIAM_DEEQUIP")
					if memoriam != null: 
						memoriam._exit(_pl)
						memoriam.queue_free()
				
			_ef._exit(_pl)
			_ef._unapply(_pl)
			PLInstance.equipment_pending = null)
	
		if !_skip_anim:
			_pl.effect_equip_anim.play("effect_deequip")
			_pl.effect_equip_node.rotation = randf_range(0, PI)
		else:
			effect_deequip_anim_end.on_notify()

# ----> Update.
func _input_memoriam(_input: InputEvent, _pl: Player) -> void: if memoriam != null: memoriam.input(_input, _pl)
func _input_effect(_input: InputEvent, _pl: Player) -> void: if effect != null: effect.input(_input, _pl)


func _physics_update(_delta: float) -> void:
	if memoriam != null: memoriam._physics_update(_delta, sentient)
	if effect != null: effect._physics_update(_delta, sentient)
func _update(_delta: float) -> void:
	if memoriam != null: memoriam._update(_delta, sentient)
	if effect != null: effect._update(_delta, sentient)
	
	
