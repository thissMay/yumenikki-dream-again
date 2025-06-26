extends HFSM

var player_setup: bool = false
@export var active_exclusive_cr: ComponentReceiver

func _setup() -> void:
	super()
	Player.Instance.setup()

func enter_state() -> void:
	super()		
	active_exclusive_cr.set_bypass(false)
	GameManager.set_ui_visibility(true)
	
func exit_state() -> void:
	super()
	active_exclusive_cr.set_bypass(false)
