class_name InputManager
extends Node

static var vector_input: Vector2
var scheme: Keybind

func _ready() -> void:
	scheme = Keybind.new()
	
	for i in (scheme.bind): 
		InputMap.add_action(i)
		for k in scheme.bind[i]["key"]: 
			InputMap.action_add_event(i, k)
		
func _process(_delta: float) -> void: 
	vector_input = Vector2(
		int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")),
		int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
		)
		
func key_command(_key_id: String) -> void:
	if Input.is_action_pressed(_key_id) and _key_id in scheme.bind:
		scheme.bind[_key_id]["command"]

class InputAction:
	extends InputEventKey
	var command: Command
	
	func _init(_key: Key, _command: Command = null) -> void: 
		keycode = _key
		command = _command
	
class Keybind:
	extends Object
	
	var bind: Dictionary = {
		"esc_menu" 			: { "key" : [ InputAction.new(KEY_ESCAPE) ], "command" : []},
		"hud_toggle" 		: { "key" : [ InputAction.new(KEY_TAB) ], "command" : []},
		
		"sprint" 			: { "key" : [ InputAction.new(KEY_SHIFT) ], "command" : []},
		"sneak" 			: { "key" : [ InputAction.new(KEY_CTRL) ], "command" : []},
		
		"move_up" 			: { "key" : [ InputAction.new(KEY_UP), InputAction.new(KEY_W) ], "command" : []},
		"move_down" 		: { "key" : [ InputAction.new(KEY_DOWN), InputAction.new(KEY_S) ], "command" : []},
		"move_right" 		: { "key" : [ InputAction.new(KEY_RIGHT), InputAction.new(KEY_D) ], "command" : []},
		"move_left" 		: { "key" : [ InputAction.new(KEY_LEFT), InputAction.new(KEY_A) ], "command" : []},
		
		"pinch" 			: { "key" : [InputAction.new(KEY_Q)], "command" : []},
		"interact" 			: { "key" : [InputAction.new(KEY_E)], "command" : []},
		"emote" 			: { "key" : [InputAction.new(KEY_G)], "command" : []},
		"primary_action"	: { "key" : [InputAction.new(KEY_Z)], "command" : []},
		"secondary_action" 	: { "key" : [InputAction.new(KEY_X)], "command" : []},
		
		"inventory" 		: { "key" : [InputAction.new(KEY_ALT)], "command" : []},
		"favourite_effect" 	: { "key" : [InputAction.new(KEY_F)], "command" : []},
		}
