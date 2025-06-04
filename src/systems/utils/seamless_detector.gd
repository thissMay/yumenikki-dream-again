@tool

class_name SeamlessDetector
extends Node2D

var loop_count: int

const screen_size := Vector2i(480, 270)
@export var tile_size: Vector2i = Vector2i(16, 16)
@export var expansion: Vector2i

@export_group("READ-ONLY")
@export var boundary_size: Vector2i:
	get:
		return (min_bound_size_multiplier * tile_size) + (expansion * tile_size)
@export var min_bound_size_multiplier: Vector2i:
	get: return Vector2(screen_size / (tile_size))
@export var min_boundary_size: Vector2i:
	get: return round(min_bound_size_multiplier * tile_size)

enum bound_side {UP, DOWN, RIGHT, LEFT}
enum loop {LOOP, DISABLED}

# ---- loop components ---- 
@onready var up: Area2D = $up_loop
@onready var down: Area2D = $down_loop
@onready var right: Area2D = $right_loop
@onready var left: Area2D = $left_loop

# ---- collision components ----
@onready var up_collision: StaticBody2D = $up_coll
@onready var down_collision: StaticBody2D = $down_coll
@onready var right_collision: StaticBody2D = $right_coll
@onready var left_collision: StaticBody2D = $left_coll

@onready var up_bound: CollisionShape2D = $up_loop/square
@onready var down_bound: CollisionShape2D = $down_loop/square
@onready var right_bound: CollisionShape2D = $right_loop/square
@onready var left_bound: CollisionShape2D = $left_loop/square

# ---- bound flags ----
@export var up_disabled: bool:
	set(dis): 
		up_disabled = dis
		set_bound_loop_mode(bound_side.UP)
@export var down_disabled: bool:
	set(dis): 
		down_disabled = dis
		set_bound_loop_mode(bound_side.DOWN)
@export var right_disabled: bool:
	set(dis): 
		right_disabled = dis
		set_bound_loop_mode(bound_side.RIGHT)
@export var left_disabled: bool:
	set(dis): 
		left_disabled = dis
		set_bound_loop_mode(bound_side.LEFT)

@export var  horizontal_size: Vector2i
@export var  vertical_size: Vector2i

func _ready() -> void: 
	if !Engine.is_editor_hint(): 
		resize(boundary_size)
		player_entered_setup()
		queue_redraw()
		set_process(false)
		
	set_bound_active(bound_side.UP, up_disabled)
	set_bound_active(bound_side.DOWN, down_disabled)
	set_bound_active(bound_side.RIGHT, right_disabled)
	set_bound_active(bound_side.LEFT, left_disabled)
func _process(delta: float) -> void:
	if Engine.is_editor_hint(): 
		resize(boundary_size)
		queue_redraw()
func _draw() -> void:
	if Engine.is_editor_hint():
		# ---- outer warp bounds
		
		var v_size := Vector2i(boundary_size.x + 480 , clampf(min_boundary_size.y / 2 + tile_size.y * 2, 0, 300))
		var h_size := Vector2i(clampf(min_boundary_size.x / 2 + tile_size.x * 2, 0, 500), min_boundary_size.y + clampf(min_boundary_size.y / 2 + tile_size.y * 2, 0, 300) * 7)
		
		var v_size_mirrored := Vector2i(boundary_size.x + 480, clampf(min_boundary_size.y / 2 + tile_size.y * 2, 0, 300))
		var h_size_mirrored := Vector2i(h_size.x, boundary_size.y)
		
		var pos_up_overshoot := Vector2(up.position.x - v_size.x / 2, up.position.y - tile_size.y / 2)
		var pos_down_overshoot := Vector2(down.position.x - v_size.x / 2, down.position.y * 2 - v_size.y + tile_size.y)
		
		var pos_up_mirrored := Vector2(up.position.x - v_size.x / 2 , up.position.y - (tile_size.y * 3/2))
		var pos_down_mirrored := Vector2(down.position.x - v_size.x / 2 , down.position.y + (tile_size.y * 3/2))
		
		# ---
		
		var pos_left_overshoot := Vector2(left.position.x - min_boundary_size.x / 2 - (tile_size.x * 3/2) , left.position.y - h_size.y / 2 )
		var pos_right_overshoot := Vector2(right.position.x + min_boundary_size.x / 2 + (tile_size.x * 3/2) , right.position.y - h_size.y / 2 )
		
		var pos_left_mirror := Vector2(right.position.x - (tile_size.x * 3/2), right.position.y - boundary_size.y / 2)
		var pos_right_mirror := Vector2(left.position.x + (tile_size.x * 3/2), left.position.y - boundary_size.y / 2)
		
		
		# --- up and down
		if !up_disabled or !down_disabled:
			# ---- down overshoot
			draw_rect(Rect2(pos_down_overshoot, v_size), Color(Color.AQUA, .275))
			# ---- up overshoot
			draw_rect(Rect2(pos_up_overshoot , v_size), Color(Color.BLUE, .275))
			# ---- down mirrored
			draw_rect(Rect2(pos_down_mirrored, v_size_mirrored), Color(Color.BLUE, .275))
			# ---- up mirrored
			draw_rect(Rect2(pos_up_mirrored, Vector2(v_size_mirrored.x, -v_size_mirrored.y)), Color(Color.AQUA, .275)) 
			
			draw_string(preload("res://fonts/FIRACODE-VARIABLEFONT_WGHT.TTF"), Vector2(boundary_size.x / 2, up.position.y + tile_size.y / 2), "LOOK AHEAD, WARP UP", HORIZONTAL_ALIGNMENT_CENTER, -1, 32, )
			draw_string(preload("res://fonts/FIRACODE-VARIABLEFONT_WGHT.TTF"), Vector2(boundary_size.x / 2, down.position.y + tile_size.y * 2), "WARP UP", HORIZONTAL_ALIGNMENT_CENTER, -1, 32, )
		
		# --- right and left
		if !right_disabled or !left_disabled:
			draw_rect(Rect2(Vector2(pos_right_overshoot.x - h_size.x, -tile_size.y * 10 ), Vector2(h_size.x, boundary_size.y + tile_size.y * 20 )), Color(Color.RED, .275)) # ---- right overshoot
			draw_rect(Rect2(Vector2(pos_left_overshoot.x, -tile_size.y * 10), Vector2(h_size.x, boundary_size.y + tile_size.y * 20 )), Color(Color.CORNFLOWER_BLUE, .275)) # ---- left overshoot
			
			# ----> RIGHT
			
			draw_rect(Rect2(left.position.x + (tile_size.x * 3/2), left.position.y - boundary_size.y / 2, h_size_mirrored.x, h_size_mirrored.y), Color(Color.RED, .275)) # ---- right mirrored
			draw_rect(Rect2(right.position.x - (tile_size.x * 3/2), right.position.y - boundary_size.y / 2, -h_size_mirrored.x , h_size_mirrored.y), Color(Color.CORNFLOWER_BLUE, .275)) # ---- left mirrored
			
			draw_string(preload("res://fonts/FIRACODE-VARIABLEFONT_WGHT.TTF"), Vector2(right.position.x, boundary_size.y / 2), "LOOK AHEAD, WARP RIGHT", HORIZONTAL_ALIGNMENT_CENTER, -1, 32, )
			draw_string(preload("res://fonts/FIRACODE-VARIABLEFONT_WGHT.TTF"), Vector2(left.position.x, boundary_size.y / 2), "WARP RIGHT", HORIZONTAL_ALIGNMENT_CENTER, -1, 32, )
		
func resize(new_size: Vector2) -> void:
	# --------------------------- size
	(up_bound.shape as RectangleShape2D).size.x = new_size.x
	(down_bound.shape as RectangleShape2D).size.x = new_size.x
	
	(up_bound.shape as RectangleShape2D).size.y = tile_size.y
	(down_bound.shape as RectangleShape2D).size.y = tile_size.y
	
	(right_bound.shape as RectangleShape2D).size.y = new_size.y
	(left_bound.shape as RectangleShape2D).size.y = new_size.y
	
	(right_bound.shape as RectangleShape2D).size.x = tile_size.x
	(left_bound.shape as RectangleShape2D).size.x = tile_size.x
	
	# --------------------------- pos
	up.position = Vector2(
		(up_bound.shape as RectangleShape2D).size.x / 2, 
		boundary_size.y + (up_bound.shape as RectangleShape2D).size.y / 2)
	
	down.position = Vector2(
		(down_bound.shape as RectangleShape2D).size.x / 2, 
		-(down_bound.shape as RectangleShape2D).size.y / 2)
	
	right.position = Vector2(
		boundary_size.x + (right_bound.shape as RectangleShape2D).size.x / 2, 
		(right_bound.shape as RectangleShape2D).size.y / 2)
	
	left.position = Vector2(
		-(left_bound.shape as RectangleShape2D).size.x / 2, 
		(left_bound.shape as RectangleShape2D).size.y / 2)

func player_entered_setup() -> void:
	up.area_entered.connect(func(_p): player_hit_border(_p, bound_side.UP))
	down.area_entered.connect(func(_p): player_hit_border(_p, bound_side.DOWN))
	right.area_entered.connect(func(_p): player_hit_border(_p, bound_side.RIGHT))
	left.area_entered.connect(func(_p): player_hit_border(_p, bound_side.LEFT))	
func player_hit_border(_player: Area2D, _bound_side: bound_side) -> void: 
	if is_instance_valid(_player) and PLInstance.get_pl() != null:
		if _player == PLInstance.get_pl().world_warp:
			GameManager.EventManager.invoke_event("WORLD_LOOP")
			loop_count += 1
			
			match _bound_side:
				bound_side.UP: _handle_player_warp_up(_player)
				bound_side.DOWN: _handle_player_warp_down(_player)
				bound_side.RIGHT: _handle_player_warp_right(_player)
				bound_side.LEFT: _handle_player_warp_left(_player)

func _handle_player_warp_left(_pl: Area2D) -> void: 
	PLInstance.handle_player_world_warp(
		Vector2(right.global_position.x - (tile_size.x * 3/2), _pl.global_position.y), 
		PLInstance.get_pl().direction)
func _handle_player_warp_right(_pl: Area2D) -> void: 
	PLInstance.handle_player_world_warp(
		Vector2(left.global_position.x + (tile_size.x * 3/2), _pl.global_position.y), 
		PLInstance.get_pl().direction)
func _handle_player_warp_up(_pl: Area2D) -> void: 
	PLInstance.handle_player_world_warp(
		Vector2(_pl.global_position.x, down.global_position.y + (tile_size.y * 3/2)), 
		PLInstance.get_pl().direction)
func _handle_player_warp_down(_pl: Area2D) -> void: 
	PLInstance.handle_player_world_warp(
		Vector2(_pl.global_position.x, up.global_position.y - (tile_size.y * 3/2)), 
		PLInstance.get_pl().direction)

func set_bound_active(_bound: bound_side, _active: bool = true) -> void:
	match _bound:
		bound_side.UP: up_disabled = _active		
		bound_side.DOWN: down_disabled = _active
		bound_side.RIGHT: right_disabled = _active
		bound_side.LEFT: left_disabled = _active
func set_bound_loop_mode(_bound: bound_side) -> void: 
	match _bound:
			bound_side.UP: if up_collision: up_bound.reparent(up_collision if up_disabled else up)
			bound_side.DOWN: if down_collision: down_bound.reparent(down_collision if down_disabled else down)
			bound_side.RIGHT: if right_collision: right_bound.reparent(right_collision if right_disabled else right)
			bound_side.LEFT: if left_collision: left_bound.reparent(left_collision if left_disabled else left)
