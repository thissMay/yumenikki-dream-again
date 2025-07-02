class_name OnInteract
extends Sequence

var interactable: Interactable

func _ready() -> void: 
	super()
	interactable = get_parent()
	
	if interactable != null and interactable is Interactable:
		interactable.interacted.connect(_execute)
	
	process_mode = Node.PROCESS_MODE_DISABLED	
	
