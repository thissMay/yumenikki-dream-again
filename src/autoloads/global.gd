extends Control

const TWEEN_SCALE := 3.75

# ---- input. ----
var keybinds := SentientController.SentientKeybind.new()

var input: Dictionary 
var any_key: bool
var any_key_down: bool
var any_key_up: bool

var horizontal_pos: int
var horizontal_neg: int
var vertical_pos: int
var vertical_neg: int

var horizontal_total: int
var vertical_total: int

var global_input_event: InputEventKey

var mouse_pos: Vector2

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS	
	Input.set_custom_mouse_cursor(preload("res://src/images/mouse/mouse_normal.png"), Input.CURSOR_ARROW)
	Input.set_custom_mouse_cursor(preload("res://src/images/mouse/mouse_hover.png"), Input.CURSOR_POINTING_HAND)

func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey: 
		global_input_event = event
		input = input_info(event)
func input_info(_input: InputEventKey) -> Dictionary:
	var info := {
		"key_label" : OS.get_keycode_string(_input.key_label),
		"key_pressed" : _input.keycode,
		"pressed_once" : _input.pressed and !_input.is_echo(),
		"held_down" : _input.pressed,
		"released" : !_input.pressed
		}
	
	any_key = info["key_pressed"]
	any_key_down = info["held_down"]
	any_key_up = info["released"]
	
	return info

func calculate_input_values(
	neg_vertical: Vector2i, 
	neg_horizontal: Vector2i, 
	pos_vertical: Vector2i, 
	pos_horizontal: Vector2i) -> void:
	
	vertical_neg = 1 if key_held_down(neg_vertical) else 0
	vertical_pos = 1 if key_held_down(pos_vertical) else 0
	
	horizontal_pos = 1 if key_held_down(pos_horizontal) else 0
	horizontal_neg = 1 if key_held_down(neg_horizontal) else 0

		
	vertical_total = vertical_pos - vertical_neg
	horizontal_total = horizontal_pos - horizontal_neg
func key_held_down(primary_secondary: Vector2i) -> bool:
	if 	(Input.is_key_pressed((primary_secondary.x)) || 
		(Input.is_key_pressed(primary_secondary.y))):
		return true
	return false

func get_mouse_position_within_vp() -> Vector2:
	return clamp(Game.main_viewport.get_mouse_position(), Vector2.ZERO, Game.get_viewport_dimens())
func get_mouse_position() -> Vector2:
	return Game.main_viewport.get_mouse_position() - (Game.get_viewport_dimens() / 2)

func _process(_delta: float) -> void:
	calculate_input_values(
		Vector2i(keybinds.primary_move_up_key, keybinds.secondary_move_up_key),
		Vector2i(keybinds.primary_move_left_key, keybinds.secondary_move_left_key),
		Vector2i(keybinds.primary_move_down_key, keybinds.secondary_move_down_key),
		Vector2i(keybinds.primary_move_right_key, keybinds.secondary_move_right_key)
		)
