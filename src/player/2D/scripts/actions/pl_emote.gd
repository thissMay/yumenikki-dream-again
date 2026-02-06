class_name PLEmote
extends PLAction

const EMOTE_PATH := "emote/"
@export var enter_anim: StringName
@export var exit_anim: StringName
@export var speed: float = 1

var can_exit: bool = false

func _action_update(_pl: Player, _delta: float) -> void: 
	if !can_exit:
		can_exit = !_pl.components.get_component_by_name(Player_YN.Components.ACTION).is_cooldown
	
	if 	can_exit and \
		(_pl.desired_speed > 0 or Input.is_action_just_pressed("pl_emote")):
			_pl.components.get_component_by_name(Player_YN.Components.ACTION).cancel_action(_pl)
		
func _perform(_pl: Player) -> void: 
	if enter_anim.is_empty(): return
	
	can_exit = false
	_pl.vel_input = Vector2.ZERO
	_pl.dir_input = Vector2.ZERO
	_pl.velocity = Vector2.ZERO
	
	_pl.force_change_state("action")
	
	if  _pl.components.get_component_by_name(Player_YN.Components.ANIMATION) != null:
		_pl.components.get_component_by_name(Player_YN.Components.ANIMATION).play_animation(str(EMOTE_PATH + enter_anim))
	
		if _pl.components.get_component_by_name(Player_YN.Components.ANIMATION).loop_type == Animation.LoopMode.LOOP_NONE: 
			await _pl.components.get_component_by_name(Player_YN.Components.ANIMATION).animation_player.animation_finished
		
func _cancel(_pl: Player) -> void:
	if  _pl.components.get_component_by_name(Player_YN.Components.ANIMATION) != null:
		_pl.components.get_component_by_name(Player_YN.Components.ANIMATION).play_animation(str(EMOTE_PATH + exit_anim))
	
		if _pl.components.get_component_by_name(Player_YN.Components.ANIMATION).loop_type == Animation.LoopMode.LOOP_NONE and \
			!exit_anim.is_empty():
			
			await _pl.components.get_component_by_name(Player_YN.Components.ANIMATION).animation_player.animation_finished 	
	
	_pl.force_change_state("idle")

func _force_cancel	(_pl: Player) -> void: 
	_pl.force_change_state("idle")
