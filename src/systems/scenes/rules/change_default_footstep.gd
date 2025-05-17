class_name Rule_ChangeDefaultFootstep
extends SceneRule

@export var default_footstep_override: Footstep.mat
# ---- virtual ----
func apply_on_scene_load() -> void: 
	Footstep.default_footstep = default_footstep_override
func unapply_on_scene_unload() -> void:
	Footstep.default_footstep = Footstep.mat.NULL
