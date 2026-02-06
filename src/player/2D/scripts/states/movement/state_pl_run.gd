extends SBState

@export var sb_sprint: SBSprint
var library_path := "normal"

func _state_enter() -> void: 	
	
	sentient.components.get_component_by_name("animation_manager").play_animation(str(library_path, '/', "run"))
	(sentient as Player_YN).set_texture_using_sprite_sheet("run")

func _state_update(_delta: float) -> void:
	if !sentient.values.can_sprint or \
	sentient.is_exhausted:
		request_transition_to("walk")

func _state_physics_update(_delta: float) -> void:
	sentient.get_behaviour()._run(sentient, _delta)
