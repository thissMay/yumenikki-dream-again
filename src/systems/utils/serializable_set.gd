class_name SerializableSet extends Resource
@export var arr: Array

var i: int = 0
var s: int = 0

func pick_random() -> Variant: 
	i = randi_range(0, arr.size() - 1)
	while arr[i] == null and verify_resource_validity(arr[i]): 
		i = randi_range(0, arr.size() - 1)
	return arr[i]

func size() -> int:
	for i in range(arr.size()): 
		if arr[i]: s += 1
	return s

func verify_resource_validity(_res: Variant) -> bool: 
	return _res is Resource and !_res.resource_path.is_empty()
	
