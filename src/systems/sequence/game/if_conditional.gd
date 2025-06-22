class_name ConditionalSequence
extends Sequence

var else_conditional: Sequence

func _execute() -> void:
	if _predicate(): super()
	elif else_conditional != null: else_conditional._execute()

func _predicate() -> bool:
	return true
