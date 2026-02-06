class_name SBVariables
extends Resource

@export_group("Speed & Multipliers")
@export var walk_multi: 	float = 1
@export var sprint_multi: 	float = 1
@export var sneak_multi: 	float = 1

@export_group("Stats Flags.")
@export var can_sprint: 	bool = true
@export var can_sneak: 		bool = true
@export var auto_sprint: 	bool = false

@export_group("Noise Multipliers")
@export var walk_noise_multi: 		float = 1
@export var sneak_noise_multi: 		float = 1
@export var sprint_noise_multi: 	float = 1
