class_name PLActionManager 
extends SBComponent

var prev_action: PlayerAction
var action: PlayerAction

var cooldown: float = .8
var cooldown_timer: Timer

var is_action: bool = false
var can_action: bool = true

signal did_something

func _setup(_pl: SentientBase) -> void:
	super(_pl)
	
	cooldown_timer = $timer
	cooldown_timer.wait_time = cooldown
	cooldown_timer.autostart = false
	cooldown_timer.one_shot = true
	
	cooldown_timer.timeout.connect(func(): can_action = true)

	did_something.connect(flag_false_can_action)
	
# ---- action setters ----
func set_action(_action: PlayerAction) -> void: 
	prev_action = action	
	action = _action

func perform_action(_action: PlayerAction, _pl: Player) -> void: 
	if _action and can_action: 
		set_action(_action)
		_action._perform(_pl)
		did_something.emit()
func cancel_action(_action: PlayerAction, _pl: Player) -> void: 
	if _action and can_action:
		set_action(null) 
		_action._exit(_pl)

func get_curr_action() -> PlayerAction: return action
func get_prev_action() -> PlayerAction: return prev_action

func set_emote(_emote: PlayerEmote) -> void: 
	PLInstance.player.emote = _emote
func perform_emote(_emote: PlayerEmote, _pl: Player) -> void:
	perform_action(_emote, _pl)
func cancel_emote(_emote: PlayerEmote, _pl: Player) -> void: 
	cancel_action(_emote, _pl)

# ---- action executes / cancels ----
func handle_action_enter() -> void: if action: action._enter(sentient)
func handle_action_exit() -> void: if action: action._exit(sentient)

func handle_action_input(_input: InputEvent) -> void: if action: action._input(sentient, _input)
func handle_action_phys_update(_delta: float) -> void: if action: action._physics_update(sentient, _delta)
func handle_action_update(_delta: float) -> void: if action: action._update(sentient, _delta)

func _physics_update(_delta: float) -> void: handle_action_phys_update(_delta)
func _update(_delta: float) -> void: handle_action_update(_delta)

func _input(event: InputEvent) -> void: 
	if event is InputEventKey && Global.input: handle_action_input(event)

# ---- action executes / cancels ----
func flag_false_can_action() -> void: 
	can_action = false
	cooldown_timer.start()
