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
	animation_player = get_node("animation_player")
	
	sentient = _sentient 
	sprite_renderer = sentient.sprite_renderer	
	
	(sentient.sprite_renderer as SpriteSheetFormatter).set_row(sentient.heading)
func _update(_delta: float) -> void:
	handle_sprite_flip(sentient)
	handle_sprite_subtle_rotation(sentient)		
	handle_sprite_direction(sentient)

	if sentient.is_moving: 
		animation_player.speed_scale = clamp(.21 * log(sentient.speed / sentient.MAX_SPEED) + 1, 0, INF)
	else: animation_player.speed_scale = 1
		
# --- handler functions ---
func handle_sprite_subtle_rotation(_sentient: SentientBase) -> void:
	if _sentient != null:
		_sentient.sprite_renderer.rotation_degrees = lerp(
			_sentient.sprite_renderer.rotation_degrees, 
			sign(_sentient.direction.x) * abs((_sentient.velocity.x / _sentient.initial_speed) * dynamic_rot_intensity * dynamic_rot_multi),
			(get_process_delta_time()) / _sentient.TRANS_WEIGHT)
func handle_sprite_flip(_sentient: SentientBase) -> void:
	if _sentient != null:
		if _sentient.get_lerped_dir().x < 0: _sentient.sprite_renderer.flip_h = true
		else: _sentient.sprite_renderer.flip_h = false
func handle_sprite_direction(_sentient: SentientBase) -> void:
	_sentient.sprite_renderer.set_row(lerpf(
	_sentient.sprite_renderer.row, _sentient.heading, 
	0.3))
	
func set_sprite_direction(_sentient: SentientBase, _heading: Entity.compass_headings) -> void: 
	_sentient.sprite_renderer.set_row(_heading)
	
func set_dynamic_rot_multi(_multi: float) -> void:
	dynamic_rot_multi = _multi

func play_animation(_path: String, _speed: float = 1, _backwards: bool = false) -> void:
	if can_play: animation_player.play(_path, -1 ,_speed, _backwards)
func play_animation_priority(_path: String, _speed: float = 1, _backwards: bool = false) -> void:
	play_animation(_path, _speed, _backwards)
	can_play = false
