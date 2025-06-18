class_name PLInventoryData
extends Resource

@export var effects: Array[PLEffect]

func get_effects_path() -> Array:
	var paths: Array
	for e in effects:
		if e: paths.append(e.resource_path)
	
	return paths
