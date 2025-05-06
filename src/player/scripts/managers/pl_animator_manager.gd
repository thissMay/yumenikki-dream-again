class_name PLAnimationManager
extends SentientAnimator

var action_anim_node: AnimationNodeAnimation 
var emote_enter_anim_node: AnimationNodeAnimation 
var emote_exit_anim_node: AnimationNodeAnimation 

# --- setup functions --- 
func _setup(_sentient: SentientBase) -> void:
	super(_sentient)
	(sentient.sprite_renderer as SpriteSheetFormatter).set_row(sentient.heading)

func update(_delta: float) -> void:
	super(_delta)
	
	sentient.sprite_renderer.set_row(lerpf(
		sentient.sprite_renderer.row, sentient.heading, 
		0.3))
	if sentient.is_moving: 
		animation_player.speed_scale = clamp(.21 * log(sentient.speed / sentient.MAX_SPEED) + 1, 0, INF)
	else: animation_player.speed_scale = 1

# ---- setters. ----
func set_emote_enter_anim(_path: String) -> void: 
	emote_enter_anim_node.animation = _path
func set_emote_exit_anim(_path: String) -> void: 
	emote_exit_anim_node.animation = _path
func set_action_anim(_path: String) -> void: 
	action_anim_node.animation = _path

# ---- getters. ----
func get_emote_enter_anim() -> String:
	return emote_enter_anim_node.animation
func get_emote_exit_anim() -> String: 
	return emote_exit_anim_node.animation

# ---- control. ----
func revert_emote_anim() -> void: 
	emote_enter_anim_node.animation = PLInstance.def_emote.get_anim_path() if PLInstance.def_emote else ""
func revert_action_anim() -> void: 
	action_anim_node.animation = ""
