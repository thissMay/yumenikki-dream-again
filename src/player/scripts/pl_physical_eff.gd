class_name PLPhysicalEff
extends Node

var action: PlayerAction

# ---- 	DO NOT TOUCH THESE 	----
func _enter(_pl: Player) -> void: pass
func _exit(_pl: Player) -> void: pass
# ----						----
func _physics_update(_delta: float, _pl: Player) -> void: pass
func _update(_delta: float, _pl: Player) -> void: pass
func input(_input: InputEvent, _pl: Player) -> void: pass

# ---- VIRTUAL
func _perform(_pl: Player) -> void: pass

func has_action() -> bool: return action != null
