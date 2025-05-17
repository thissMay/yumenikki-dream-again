class_name InteractTrigger
extends SequenceCaller

var interactable: Interactable

func _ready() -> void:
	interactable = get_parent()
	if interactable is Interactable:
		interactable.interacted.connect(_call)
