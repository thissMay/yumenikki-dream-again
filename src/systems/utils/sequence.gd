class_name Sequence extends Resource
@export var order: Array[ResourceCommand]

func execute() -> void:
	for c: ResourceCommand in order:
		if c: c._execute()
