class_name PlayerEmote
extends PlayerAction

const EMOTE_PATH := "emote/"
@export var path: String = EMOTE_PATH
@export var emote_enter_anim: String
@export var emote_exit_anim: String
@export var emote_speed: float = 1
@export var auto_exit: bool = false

func _perform(_pl: Player) -> void:
	(_pl as Player_YN).force_change_state("action")
	
func _enter(_pl: Player) -> void:
	(_pl as Player_YN).animation_manager.play_animation(get_enter_anim_path())
	
func _exit(_pl: Player) -> void:
	if !emote_exit_anim.is_empty():
		(_pl as Player_YN).animation_manager.play_animation(get_exit_anim_path())
		await (_pl as Player_YN).animation_manager.animation_player.animation_finished
	
	(_pl as Player_YN).force_change_state("idle")


func _input(_pl: Player, _input: InputEvent) -> void: 
	if ((Global.input["key_pressed"] == KEY_G and
		Global.input["held_down"])) or SentientController.get_input_vectors().abs().length() > 0 or auto_exit:
		(_pl as Player_YN).cancel_action(self)

# -------------------

func get_enter_anim_path() -> String: 
	return str(path + emote_enter_anim)
func get_exit_anim_path() -> String: return str(EMOTE_PATH + emote_exit_anim)
