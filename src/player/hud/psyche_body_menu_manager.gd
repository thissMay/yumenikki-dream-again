extends FSM

@export var mind_button: GUIPanelButton
@export var psyche_button: GUIPanelButton
@export var body_button: GUIPanelButton

func _setup() -> void: 
	self.visible = false
	
	state_dict[0] = get_node("mind")
	state_dict[1] = get_node("psyche")
	state_dict[2] = get_node("body")
	
	initial_state = state_dict[0]
	
	mind_button.button.pressed.connect(func(): _change_to_state("mind", null))
	psyche_button.button.pressed.connect(func(): _change_to_state("psyche", null))
	body_button.button.pressed.connect(func(): _change_to_state("body", null))
	
	super(s)
