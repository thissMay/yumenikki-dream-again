@tool

class_name SeamlessIndependent
extends Node2D

enum type {HORIZONTAL, VERTICAL}

const screen_size := Vector2i(480, 270)

@export var tile_size: Vector2i = Vector2i(16, 16)
@export var expansion: Vector2i

@export var loop_type: type = type.HORIZONTAL 
@export var direction_trigger: Entity.compass_headings

# ---- loop components ---- 
@onready var region: AreaRegion = $region
@export var target_region: SeamlessIndependent

# ---- bound flags ----

func _ready() -> void: 
	if !Engine.is_editor_hint(): 
		player_entered_setup()
		set_process(false)

func _draw() -> void:
	match loop_type:
		type.VERTICAL:
			
			draw_rect(
				Rect2(
					Vector2(-(region.shape.b - region.shape.a).x / 2, 0 - tile_size.y * 2), 
					Vector2((region.shape.b - region.shape.a).x, tile_size.y)),
					Color(Color.RED, 0.2))
			draw_rect(
				Rect2(
					Vector2(-(region.shape.b - region.shape.a).x / 2, 0 + tile_size.y), 
					Vector2((region.shape.b - region.shape.a).x, tile_size.y)),
					Color(Color.BLUE, 0.2))

func _process(delta: float) -> void:
	if Engine.is_editor_hint(): 
		queue_redraw()

	
func player_entered_setup() -> void:
	region.player_enter_handle.connect(func(_p): player_hit_border(_p))
	
func player_hit_border(_player: Player) -> void: 
	_handle_player_warp(_player)
			
func _handle_player_warp(_pl: Player) -> void: 
	if target_region == null or loop_type != target_region.loop_type: return
	
	
	if _pl.heading == direction_trigger:
		_pl.reparent(target_region.get_parent())
		match loop_type:
			
			type.HORIZONTAL: 
				var target_region_direction: int = sign(target_region.global_position.x - self.global_position.x)
				Player.Instance.handle_player_world_warp(
					Vector2(
						target_region.global_position.x + (1 * target_region_direction) * (tile_size.x * 3/2), _pl.global_position.y), 
						_pl.direction)
						
			type.VERTICAL:
				var target_region_direction: int = sign(target_region.global_position.y - self.global_position.y)
				Player.Instance.handle_player_world_warp(
					Vector2(_pl.global_position.x, target_region.global_position.y + 1 * target_region_direction), 
					_pl.direction)
					
