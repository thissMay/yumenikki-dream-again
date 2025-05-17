class_name Component extends Node


''' 
-- Component Class 101 -- 
	the component node will act as a child of a node.
	it will override or add new features to that node.
	the node in question will be the parent that it is a child of.

-- Target Node Info. -- 
	the target node will be of type node.
	in the concrete classes of "component", we can use assert to ensure-
	-that the component works with certain types of nodes.
'''
@export var receiver: ComponentReceiver
@export var active: bool = true:
	set(_a): 
		active = _a
		set_active(_a)

func _enter_tree() -> void: setup()

# ---- component functions ----
func set_active(_active: bool = true) -> void:
	match _active:
		false: process_mode = Node.PROCESS_MODE_DISABLED
		true: process_mode = Node.PROCESS_MODE_INHERIT

# ---- node functions ----
func setup() -> void:
	if get_parent() is ComponentReceiver: 
		receiver = get_parent()
		if !receiver.bypass_enabled.is_connected(_on_bypass_enabled): 
			receiver.bypass_enabled.connect(_on_bypass_enabled)
		if !receiver.bypass_lifted.is_connected(_on_bypass_lifted): 
			receiver.bypass_lifted.connect(_on_bypass_lifted)
	else: return
func delete() -> void: 
	self.queue_free()

# ---- virtual functions ----
func _execute() -> void: pass
func _update(_delta: float) -> void: pass
func _physics_update(_delta: float) -> void: pass

# ---- INDEPENDENT INSTANCE PROCESS ----
func _process(delta: float) -> void: 
	if active and receiver != null and !receiver.bypass:
		_update(delta)
func _physics_process(delta: float) -> void: 
	if active and receiver != null and !receiver.bypass:
		_physics_update(delta)

# ---- ON RECIEVER BYPASS ----
func _on_bypass_enabled() -> void: pass
func _on_bypass_lifted() -> void: pass

# ---- STATIC / GLOBAL FUNCS ----
static func has_component(_parent: Node, _comp: Component) -> bool: return false
static func add_component(_parent: Node, _comp: Component) -> Component:
	_parent.add_child(_comp)
	return _comp
