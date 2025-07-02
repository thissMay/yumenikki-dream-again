class_name PLActionManager 
extends SBComponent

var emote: PLEmote
var primary_action: PLAction
var secondary_action: PLAction

var curr_action: PLAction

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
func set_emote(_emote: PLEmote) -> void: emote = _emote
func set_primary_action(_prim_action: PLAction) -> void: primary_action = _prim_action
func set_secondary_action(_second_action: PLAction) -> void: secondary_action = _second_action
func set_curr_action(_action: PLAction) -> void: curr_action = _action

func perform_action(_action: PLAction, _pl: Player) -> void: 
	if _action and can_action:
		if (_pl.fsm._get_curr_state_name() in _action.supported_states and 
			_action.supported_states[_pl.fsm._get_curr_state_name()]): 
			
			did_something.emit()
			set_curr_action(_action)
			_action._perform(_pl)
func cancel_action(_action: PLAction, _pl: Player, _force: bool = false) -> void: 
	if _action and (can_action or _force):
		_action._cancel(_pl)
		set_curr_action(null)
func get_curr_action() -> PLAction: return curr_action

# ---- action handles ----
func handle_action_enter() -> void: 
	if curr_action: 
		await curr_action._enter(sentient)
func handle_action_exit() -> void: 
	if curr_action: 
		await curr_action._exit(sentient)

func handle_action_input(_input: InputEvent) -> void: if curr_action and can_action: curr_action._input(sentient, _input)
func handle_action_phys_update(_delta: float) -> void: if curr_action: curr_action._physics_update(sentient, _delta)
func handle_action_update(_delta: float) -> void: if curr_action: curr_action._update(sentient, _delta)

func _physics_update(_delta: float) -> void: handle_action_phys_update(_delta)
func _update(_delta: float) -> void: handle_action_update(_delta)
func input_pass(event: InputEvent) -> void:
	super(event)
	if Input.is_action_just_pressed("primary_action"): perform_action(primary_action, sentient)
	elif Input.is_action_just_pressed("secondary_action"): perform_action(secondary_action, sentient)

# ---- action executes / cancels ----
func flag_false_can_action() -> void: 
	can_action = false
	cooldown_timer.start()
