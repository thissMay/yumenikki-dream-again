class_name Sequence extends Resource
@export var order: Array[ResourceEvent]

func execute() -> void:
	for c: ResourceEvent in order:
		if c: c._execute()
