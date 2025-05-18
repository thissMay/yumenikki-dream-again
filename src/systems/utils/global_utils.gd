class_name GlobalUtils

static func is_within_exclusive(_num: float, _min: float, _max: float) -> bool:
	return ((_num < _min) and (_num > _max))
static func is_within_inclusive(_num: float, _min: float, _max: float) -> bool:
		return ((_num <= _min) and (_num >= _max))

class Predicate:
	static func evaluate(_expression: bool) -> bool: return _expression
