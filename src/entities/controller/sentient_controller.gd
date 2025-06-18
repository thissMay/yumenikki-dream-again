class_name SentientController
extends RefCounted
'''
controllers define how the player works.
we'll have two different controllers: key-board only, and kbm.
'''
var sentient: SentientBase

static var inp_x: float = 0
static var inp_y: float = 0

func update(_delta: float) -> void:
	pass_input(Global.horizontal_total, Global.vertical_total)
func pass_input(x: float, y: float) -> void:
	inp_x = clamp(x, -1, 1)
	inp_y = clamp(y, -1, 1)

static func get_input_vectors() -> Vector2: 
	return Vector2(inp_x, inp_y)

class SentientKeybind:
	extends Object
	
	var sprint_key := KEY_SHIFT
	var sneak_key := KEY_CTRL

	var primary_move_up_key := KEY_UP
	var primary_move_right_key := KEY_RIGHT
	var primary_move_left_key := KEY_LEFT
	var primary_move_down_key := KEY_DOWN

	var secondary_move_up_key := KEY_W
	var secondary_move_right_key := KEY_D
	var secondary_move_left_key := KEY_A
	var secondary_move_down_key := KEY_S
	
	var interact_key := KEY_E
	var emote_key := KEY_G
	
	var action_key := MOUSE_BUTTON_LEFT
	var alt_action_key := MOUSE_BUTTON_RIGHT
	
	var player_menu_key := KEY_SPACE
	
