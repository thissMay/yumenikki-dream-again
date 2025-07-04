@tool

class_name SeamlessDetector
extends Node2D

signal pl_warped_right
signal pl_warped_left
signal pl_warped_up
signal pl_warped_down


var loop_record  := {
	bound_side.UP: 0,
	bound_side.DOWN: 0,
	bound_side.RIGHT: 0,
	bound_side.LEFT: 0,
}
var sentients_to_be_looped := {
	bound_side.UP : [],
	bound_side.DOWN : [],
	bound_side.RIGHT : [],
	bound_side.LEFT : [],
}

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

# ----
var v_size: Vector2
var h_size: Vector2
var v_size_mirrored: Vector2
var h_size_mirrored: Vector2
var pos_up_overshoot: Vector2
var pos_down_overshoot: Vector2
var pos_up_mirrored: Vector2
var pos_down_mirrored: Vector2
var pos_left_overshoot: Vector2
var pos_right_overshoot: Vector2
var pos_left_mirror: Vector2
var pos_right_mirror: Vector2

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
		
		v_size = Vector2i(boundary_size.x + 480 , clampf(min_boundary_size.y / 2 + tile_size.y * 2, 0, 300))
		h_size = Vector2i(clampf(min_boundary_size.x / 2 + tile_size.x * 2, 0, 500), min_boundary_size.y + clampf(min_boundary_size.y / 2 + tile_size.y * 2, 0, 300) * 7)
		
		v_size_mirrored = Vector2i(boundary_size.x + 480, clampf(min_boundary_size.y / 2 + tile_size.y * 2, 0, 300))
		h_size_mirrored = Vector2i(h_size.x, boundary_size.y)
		
		pos_up_overshoot = Vector2(up.position.x - v_size.x / 2, up.position.y - tile_size.y / 2)
		pos_down_overshoot = Vector2(down.position.x - v_size.x / 2, down.position.y * 2 - v_size.y + tile_size.y)
		
		pos_up_mirrored = Vector2(up.position.x - v_size.x / 2 , up.position.y - (tile_size.y * 3/2))
		pos_down_mirrored = Vector2(down.position.x - v_size.x / 2 , down.position.y + (tile_size.y * 3/2))
		
		# ---
		
		pos_left_overshoot = Vector2(left.position.x - min_boundary_size.x / 2 - (tile_size.x * 3/2) , left.position.y - h_size.y / 2 )
		pos_right_overshoot = Vector2(right.position.x + min_boundary_size.x / 2 + (tile_size.x * 3/2) , right.position.y - h_size.y / 2 )
		
		pos_left_mirror = Vector2(right.position.x - (tile_size.x * 3/2), right.position.y - boundary_size.y / 2)
		pos_right_mirror = Vector2(left.position.x + (tile_size.x * 3/2), left.position.y - boundary_size.y / 2)
		
		
		# --- up and down
		if !up_disabled or !down_disabled:
			# ---- down overshoot
			draw_rect(Rect2(pos_down_overshoot, v_size), Color(Color.AQUA, .32))
			# ---- up overshoot
			draw_rect(Rect2(pos_up_overshoot , v_size), Color(Color.BLUE, .32))
			# ---- down mirrored
			draw_rect(Rect2(pos_down_mirrored, v_size_mirrored), Color(Color.BLUE, .32))
			# ---- up mirrored
			draw_rect(Rect2(pos_up_mirrored, Vector2(v_size_mirrored.x, -v_size_mirrored.y)), Color(Color.AQUA, .32)) 
			
			draw_string(preload("res://fonts/FIRACODE-VARIABLEFONT_WGHT.TTF"), Vector2(boundary_size.x / 2, up.position.y + tile_size.y / 2), "LOOK AHEAD, WARP UP", HORIZONTAL_ALIGNMENT_CENTER, -1, 32, )
			draw_string(preload("res://fonts/FIRACODE-VARIABLEFONT_WGHT.TTF"), Vector2(boundary_size.x / 2, down.position.y + tile_size.y * 2), "WARP UP", HORIZONTAL_ALIGNMENT_CENTER, -1, 32, )
		
		# --- right and left
		if !right_disabled or !left_disabled:
			draw_rect(Rect2(Vector2(pos_right_overshoot.x - h_size.x, -tile_size.y * 10 ), Vector2(h_size.x, boundary_size.y + tile_size.y * 20 )), Color(Color.RED, .32)) # ---- right overshoot
			draw_rect(Rect2(Vector2(pos_left_overshoot.x, -tile_size.y * 10), Vector2(h_size.x, boundary_size.y + tile_size.y * 20 )), Color(Color.CORNFLOWER_BLUE, .32)) # ---- left overshoot
			
			# ----> RIGHT
			
			draw_rect(Rect2(left.position.x + (tile_size.x * 3/2), left.position.y - boundary_size.y / 2, h_size_mirrored.x, h_size_mirrored.y), Color(Color.RED, .32)) # ---- right mirrored
			draw_rect(Rect2(right.position.x - (tile_size.x * 3/2), right.position.y - boundary_size.y / 2, -h_size_mirrored.x , h_size_mirrored.y), Color(Color.CORNFLOWER_BLUE, .32)) # ---- left mirrored
			
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
	up.area_entered.connect(func(_p): 
		player_hit_border(_p, bound_side.UP)
		pl_warped_up.emit())
	down.area_entered.connect(func(_p): 
		player_hit_border(_p, bound_side.DOWN)
		pl_warped_down.emit())
	right.area_entered.connect(func(_p): 
		player_hit_border(_p, bound_side.RIGHT)
		pl_warped_right.emit())
	left.area_entered.connect(func(_p): 
		player_hit_border(_p, bound_side.LEFT)
		pl_warped_left.emit())	
	
	up.body_entered.connect(func(_body: NavSentient): handle_sentient_enter(_body, bound_side.UP))
	down.body_entered.connect(func(_body: NavSentient): handle_sentient_enter(_body, bound_side.DOWN))
	right.body_entered.connect(func(_body: NavSentient): handle_sentient_enter(_body, bound_side.RIGHT))
	left.body_entered.connect(func(_body: NavSentient): handle_sentient_enter(_body, bound_side.LEFT))

	up.body_exited.connect(func(_body: NavSentient): handle_sentient_exit(_body, bound_side.UP))
	down.body_exited.connect(func(_body: NavSentient): handle_sentient_exit(_body, bound_side.DOWN))
	right.body_exited.connect(func(_body: NavSentient): handle_sentient_exit(_body, bound_side.RIGHT))
	left.body_exited.connect(func(_body: NavSentient): handle_sentient_exit(_body, bound_side.LEFT))
	
	
func player_hit_border(_pl: Area2D, _bound_side: bound_side) -> void: 
	if is_instance_valid(_pl) and Player.Instance.get_pl() != null:
		if _pl == Player.Instance.get_pl().world_warp:
			if CameraHolder.instance: 
				CameraHolder.instance.global_position = Player.Instance.get_pl().global_position
			
			_handle_sentient_warp(Player.Instance.get_pl(), _bound_side)
			loop_record[_bound_side] += 1
			GameManager.EventManager.invoke_event(
				"WORLD_LOOP", [get_warp_vectors_of_sentient(Player.Instance.get_pl())[_bound_side]])
			


func get_warp_vectors_of_sentient(_sentient: SentientBase) -> Dictionary:
	var warp_vectors := {
		bound_side.UP: Vector2(_sentient.global_position.x, down.global_position.y + (tile_size.y * 3/2)),
		bound_side.DOWN: Vector2(_sentient.global_position.x, up.global_position.y - (tile_size.y * 3/2)),
		bound_side.RIGHT: Vector2(left.global_position.x + (tile_size.x * 3/2), _sentient.global_position.y),
		bound_side.LEFT: Vector2(right.global_position.x - (tile_size.x * 3/2), _sentient.global_position.y)
	}
	return warp_vectors


func _handle_sentient_warp(_sentient: SentientBase, _side: bound_side) -> Vector2: 
	var warp_vectors := get_warp_vectors_of_sentient(_sentient)
	var warp_vector: Vector2 = warp_vectors[_side]
	
	_sentient.global_position = warp_vector
	_sentient.direction = (_sentient.direction)
	
	return warp_vector

func handle_sentient_enter(_wanderer: SentientBase, _side: bound_side) -> void:
	if _wanderer is NavSentient:
		sentients_to_be_looped[_side].append(_wanderer)
func handle_sentient_exit(_wanderer: SentientBase, _side: bound_side) -> void:
	if _wanderer is NavSentient:
		print(sentients_to_be_looped[_side])
		if _wanderer in sentients_to_be_looped[_side]: 
			(sentients_to_be_looped[_side] as Array).remove_at((sentients_to_be_looped[_side] as Array).find(_wanderer))

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
