class_name PLBehaviour
extends Resource

# ---- behaviour enter - exit ----
func _enter(_pl: Player) -> void: pass	
func _exit(_pl: Player) -> void: pass

# ---- behaviour apply - unapply ----
func _apply(_pl: Player) -> void: _pl.set_behaviour(self)
func _unapply(_pl: Player) -> void: _pl.revert_def_behaviour()

# ---- movement ----
func _idle(_pl: Player) -> void: 
	_pl.handle_velocity(_pl.input)
	if _pl.speed > 0: _pl.force_change_state("walk")
	
func _walk(_pl: Player, _dir: Vector2) -> void: 
	_pl.handle_velocity(_dir,  _pl.exhaust_multiplier if _pl.is_exhausted else _pl.walk_multiplier)
	
	if (_pl.stamina > 0 
		&& !_pl.is_exhausted
		&& _pl.can_run
		&& Input.is_action_pressed("sprint")): _pl.force_change_state("run")	
	if Input.is_action_pressed("sneak"): _pl.force_change_state("sneak")
		
func _run(_pl: Player, _dir: Vector2) -> void:
	_pl.handle_velocity(_dir, _pl.sprint_multiplier)
	_pl.look_at_dir(_pl.velocity.normalized())
		
	if _pl.speed <= 0 or !Input.is_action_pressed("sprint"):
		_pl.force_change_state("walk")
func _sneak(_pl: Player, _dir: Vector2) -> void:
	_pl.handle_velocity(_dir, _pl.sneak_multiplier)
	if _pl.speed == 0: _pl.force_change_state("idle")
	if !Input.is_action_pressed("sneak"):  _pl.force_change_state("walk")

func _climb(_pl: Player) -> void:
	_pl.handle_velocity(Vector2(0, _pl.walk_multiplier))

# ---- miscallenous ----
func _interact(_pl: Player, _obj: Node) -> void: 
	_pl.components.get_component_by_name("interaction_manager").handle_interaction()
func _handle_primary_action(_pl: Player) -> void: pass
func _handle_secondary_action(_pl: Player) -> void: pass

# ---- update ----
func _physics_update(_pl: Player, _delta: float) -> void: pass
