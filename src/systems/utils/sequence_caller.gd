# ---- redundant class, used in crutch cases where stuff doesn't direclty support resources
# (e.g. animation player)
class_name SequenceCaller extends Node
@export var sequence: Sequence

func _call() -> void:
	for s in sequence.order: if s: s._execute()
