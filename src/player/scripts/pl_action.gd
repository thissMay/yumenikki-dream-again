class_name PLAction
extends Resource

@export var supported_states := {
	"idle" : true,
	"walk" : false,
	"run" : false,
	"sneak" : false
}

# ---- initial
func _enter(_pl: Player) -> void: pass
func _exit(_pl: Player) -> void: pass

func _perform(_pl: Player) -> void: 
	if is_instance_of(_pl, Player_YN): (_pl as Player_YN).components.get_component_by_name("action_manager").did_something.emit()
func _cancel(_pl: Player) -> void: pass

# ---- essentials
func _update(_pl: Player, _delta: float) -> void: pass
func _physics_update(_pl: Player, _delta: float) -> void: pass
func _input(_pl: Player, _input: InputEvent) -> void: pass
