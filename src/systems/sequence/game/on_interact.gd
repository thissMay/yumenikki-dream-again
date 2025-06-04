extends Sequence

var interactable: Interactable

func _ready() -> void:
	order = get_children()
	interactable = get_parent()
	
	if interactable != null and interactable is Interactable:
		interactable.interacted.connect(_execute)
	
	process_mode = Node.PROCESS_MODE_DISABLED	
	
