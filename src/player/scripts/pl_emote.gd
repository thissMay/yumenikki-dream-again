class_name PLEmote
extends PLAction

const EMOTE_PATH := "emote/"
@export var path: String = EMOTE_PATH
@export var emote_enter_anim: String
@export var emote_exit_anim: String
@export var emote_speed: float = 1
@export var auto_exit: bool = false

func _perform(_pl: Player) -> void:
	(_pl as Player_YN).force_change_state("action")
	
func _enter(_pl: Player) -> void:
	(_pl as Player_YN).components.get_component_by_name("animation_manager").play_animation(get_enter_anim_path())
		
func _quit_emote(_pl: Player) -> void:
	if !emote_exit_anim.is_empty():
		(_pl as Player_YN).components.get_component_by_name("animation_manager").play_animation(get_exit_anim_path())
		await (_pl as Player_YN).components.get_component_by_name("animation_manager").animation_player.animation_finished

func _cancel(_pl: Player) -> void:
	(_pl as Player_YN).force_change_state("idle")


func _input(_pl: Player, _input: InputEvent) -> void: 
	if (Input.is_action_pressed("emote")  or _pl.input.length() > 0):
		await _quit_emote(_pl)
		_cancel(_pl)


func get_enter_anim_path() -> String: 
	return str(path + emote_enter_anim)
func get_exit_anim_path() -> String: return str(EMOTE_PATH + emote_exit_anim)
