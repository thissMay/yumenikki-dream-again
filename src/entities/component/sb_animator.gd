class_name SentientAnimator
extends SBComponent

var can_play: bool = true

# --- components ---
var animation_player: AnimationPlayer
var sprite_renderer: Sprite2D

# --- gimmicks ---
const DEFAULT_DYNAMIC_ROT_MULTI = 1

var dynamic_rot_intensity: float = 3.85
var dynamic_rot_multi: float = DEFAULT_DYNAMIC_ROT_MULTI

# --- setup functions --- 
func _setup(_sentient: SentientBase) -> void:
	super(_sentient)
	animation_player = get_node("animation_player")
func _update(_delta: float) -> void:

	if sentient.is_moving: 
		animation_player.speed_scale = clamp(.21 * log(sentient.speed / sentient.MAX_SPEED) + 1, 0, INF)
	else: animation_player.speed_scale = 1
		
# --- handler functions ---
func stop() -> void: animation_player.stop()
func play_animation(_path: String, _speed: float = 1, _backwards: bool = false) -> void:
	if can_play: 
		animation_player.play(_path, -1 ,_speed, _backwards)
		await animation_player.animation_finished
func play_animation_priority(_path: String, _speed: float = 1, _backwards: bool = false) -> void:
	play_animation(_path, _speed, _backwards)
	can_play = false
