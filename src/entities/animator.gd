class_name SentientAnimator
extends Node

var sentient: SentientBase
var can_play: bool = true

# --- components ---
var animation_player: AnimationPlayer
var animation_tree: AnimationTree
var sprite_renderer: Sprite2D

# --- gimmicks ---
const DEFAULT_DYNAMIC_ROT_MULTI = 1

var dynamic_rot_intensity: float = 3.85
var dynamic_rot_multi: float = DEFAULT_DYNAMIC_ROT_MULTI

# --- setup functions --- 
func _setup(_sentient: SentientBase) -> void:
	animation_player = get_node_or_null("animation_player")
	animation_tree = get_node_or_null("animation_tree")
	
	sentient = _sentient 
	sprite_renderer = sentient.sprite_renderer	
func update(_delta: float) -> void:
	handle_sprite_flip(sentient)
	handle_sprite_subtle_rotation(sentient)		
		
# --- handler functions ---
func handle_sprite_subtle_rotation(_sentient: SentientBase) -> void:
	if _sentient != null:
		_sentient.sprite_renderer.rotation_degrees = lerp(
			_sentient.sprite_renderer.rotation_degrees, 
			sign(_sentient.direction.x) * abs((_sentient.velocity.x / _sentient.initial_speed) * dynamic_rot_intensity * dynamic_rot_multi),
			(get_process_delta_time()) / _sentient.trans_weight)
func handle_sprite_flip(_sentient: SentientBase) -> void:
	if _sentient != null:
		if _sentient.get_lerped_dir().x < 0: _sentient.sprite_renderer.flip_h = true
		else: _sentient.sprite_renderer.flip_h = false

func set_dynamic_rot_multi(_multi: float) -> void:
	dynamic_rot_multi = _multi

func play_animation(_path: String, _speed: float = 1, _backwards: bool = false) -> void:
	if can_play: animation_player.play(_path, -1 ,_speed, _backwards)
func play_animation_priority(_path: String, _speed: float = 1, _backwards: bool = false) -> void:
	play_animation(_path, _speed, _backwards)
	can_play = false
