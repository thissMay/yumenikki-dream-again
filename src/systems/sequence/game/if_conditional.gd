class_name ConditionalSequence
extends Sequence

var else_conditional: Sequence

func _execute() -> void:
	if _predicate(): super()

func _predicate() -> bool:
	return true
