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
	
func append(_elem: Variant) -> void:
	if !_elem in arr: arr.append(_elem)
		

func find(_elem: Variant) -> int:
	if _elem in arr:
		return arr.find(_elem)
	return -1
func remove_at(_index: int) -> void:
	_index = clampi(_index, 0, arr.size() - 1)
	arr.remove_at(_index)
func is_empty() -> bool:
	return arr.is_empty()
