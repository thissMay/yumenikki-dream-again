class_name NavSentient
extends SentientBase

@export var nav_agent: NavigationAgent2D
@export var stance_fsm: SentientFSM
@export var behaviour_fsm: SentientFSM

var sound_player: SoundPlayer

func mandatory_components() -> void: 
	stance_fsm._setup(self)
	behaviour_fsm._setup(self)
	sound_player = get_node("sound_player")
	
func _process(delta: float) -> void:
	super(delta)
	stance_fsm._update(delta)
	behaviour_fsm._update(delta)

func _physics_process(delta: float) -> void:
	super(delta)
	stance_fsm._physics_update(delta)
	behaviour_fsm._physics_update(delta)
