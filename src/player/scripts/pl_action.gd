class_name PlayerAction
extends Resource

# ---- initial
func _enter(_pl: Player) -> void: pass
func _exit(_pl: Player) -> void: pass
func _perform(_pl: Player) -> void: 
	if is_instance_of(_pl, Player_YN): (_pl as Player_YN).components.get_component_by_name("action_manager").did_something.emit()

# ---- essentials
func _update(_pl: Player, _delta: float) -> void: pass
func _physics_update(_pl: Player, _delta: float) -> void: pass
func _input(_pl: Player, _input: InputEvent) -> void: pass
