class_name Footstep
extends SBComponent

# update the sounds later.
# one more thing: make a ground_material resource that holds a list
# of all random sound effects for the ground.

static var default_footstep: mat = mat.NULL
@export var transparent_surfaces := {
	mat.NULL 		: true,
	mat.CONCRETE 	: false,
	mat.WOOD		: false,
	mat.SNOW 		: false,
	mat.GRASS 		: false,
	mat.MUD 		: false,
	mat.BLOOD 		: false,
	mat.WATER 		: true,
	mat.CLOTH 		: false,
	mat.GLASS 		: true,
	mat.DIRT_FLESH 	: false,
}

enum mat {
	NULL 		= 0,
	CONCRETE 	= 1,
	WOOD 		= 2,
	SNOW 		= 3,
	GRASS 		= 4,
	MUD 		= 5,
	BLOOD 		= 6,
	WATER 		= 7,
	CLOTH		= 8,
	GLASS		= 9,
	DIRT_FLESH 	= 10,
	GRAVEL 		= 11
	}
var curr_material: mat
var GROUND_MAT_DICT := {
	mat.NULL 		: preload("res://src/audio/footsteps/null.tres"), 		# --- 0
	mat.CONCRETE 	: preload("res://src/audio/footsteps/concrete.tres"),	# --- 1
	mat.WOOD		: preload("res://src/audio/footsteps/wood.tres"),		# --- 2
	mat.SNOW 		: preload("res://src/audio/footsteps/snow.tres"),		# --- 3
	mat.GRASS 		: preload("res://src/audio/footsteps/grass.tres"),		# --- 4
	mat.MUD 		: preload("res://src/audio/footsteps/blood.tres"),		# --- 5
	mat.BLOOD 		: preload("res://src/audio/footsteps/blood.tres"),		# --- 6
	mat.WATER 		: preload("res://src/audio/footsteps/water.tres"),		# --- 7
	mat.CLOTH 		: preload("res://src/audio/footsteps/cloth.tres"),		# --- 8
	mat.GLASS 		: preload("res://src/audio/footsteps/glass.tres"),		# --- 9
	mat.DIRT_FLESH 	: preload("res://src/audio/footsteps/dirt_flesh.tres"),	# --- 10
	mat.GRAVEL 		: preload("res://src/audio/footsteps/gravel.tres"),	# --- 11
	}

var DEFAULT_FOOTSTEP: AudioStreamWAV = preload("res://src/audio/se/footstep_null-1.wav")
var curr_anim: CompressedTexture2D = preload("res://src/entities/footsteps/default.png")

var footstep_se_player: SoundPlayer2D
var area: Area2D

var floor_priority: TileMapLayer
var greatest_index: int = -50
var material_id: int = 0

var sound_to_be_played: AudioStream

@onready var multiple_floors := FootstepSet.new()

func _setup(_sentient: SentientBase) -> void:
	super(_sentient)
	
	footstep_se_player = $sound_player
	area = $terrain_detector
	
	area.monitorable	= true
	area.monitoring 	= true
	area.input_pickable = false
	
	await Game.main_tree.process_frame
	area.body_shape_exited.connect(_on_body_shape_exited)
	area.body_shape_entered.connect(_on_body_shape_entered)
	
	curr_material = default_footstep
	sentient.shadow_renderer.visible = transparent_surfaces[curr_material]
	footstep_se_player.max_distance = 250

func initate_footstep() -> void:  
	var sounds_set: FootstepSet = GROUND_MAT_DICT[curr_material]
	
	curr_anim = sounds_set.footstep_anim
	spawn_footstep_fx()
	
	if sound_to_be_played == null:
		play_footstep_sound(sounds_set.pick_random() if sounds_set.size() > 0 else DEFAULT_FOOTSTEP)
	else:
		play_footstep_sound(sound_to_be_played)

func spawn_footstep_fx() -> void: 
	if Game.Optimization.footstep_instances < Game.Optimization.FOOTSTEP_MAX_INSTANCES:
		var footstep_fx := FootstepDust.new(curr_anim)
		self.add_child(footstep_fx)
		footstep_fx.global_position = sentient.global_position

func play_footstep_sound(_footstep_se: AudioStream) -> void: 
	footstep_se_player.play_sound(
		_footstep_se, 
		clampf((log(sentient.get_noise() + 1)), 0.5, 1.75), 
		clampf(randf_range(0.75, sentient.get_noise()), 0.75, 1.2))	

func _on_body_shape_entered(
	body_rid: RID, 
	body: Node2D, 
	body_shape_index: int, 
	local_shape_index: int) -> void:
		
		if body is FootstepTileMap:
			multiple_floors.append(body)
			
			var tile_coords: Vector2i
			var cell_tile_data: TileData
			var atlas_coords: Vector2i
			
			for floors: TileMapLayer in multiple_floors.arr:
				tile_coords = floors.get_coords_for_body_rid(body_rid)
				atlas_coords = floors.get_cell_atlas_coords( tile_coords)
				cell_tile_data = floors.get_cell_tile_data(tile_coords)

				if cell_tile_data and cell_tile_data.z_index > greatest_index: 
					greatest_index = floors.get_cell_tile_data(floors.get_coords_for_body_rid(body_rid)).z_index
					floor_priority = floors
					break
	
			
				if transparent_surfaces[curr_material]: sentient.shadow_renderer.visible = false
				else: sentient.shadow_renderer.visible = true	
				
func _on_body_shape_exited(
	body_rid: RID, 
	body: Node2D, 
	body_shape_index: int, 
	local_shape_index: int) -> void:
		if body is TileMapLayer:
			
			if !area.overlaps_body(body):
				multiple_floors.remove_at(multiple_floors.find(body)) 
				greatest_index = -50
				
				if  multiple_floors.is_empty():
					curr_material = default_footstep
					floor_priority = null
					greatest_index = -50
					sentient.shadow_renderer.visible = false
					sound_to_be_played = null
		
class FootstepDust:
	extends SpriteSheetFormatterAnimated

	func _init(_anim: CompressedTexture2D) -> void:
		Game.Optimization.footstep_instances += 1
		
		self.frame_dimensions = Vector2i(48, 48)
		self.fps = 10
		self.loop = false
		
		self.z_index = -1
		self.offset.y = -10
		self.top_level = true
		
		
		set_sprite(_anim)	
		
	func _exit_tree() -> void:
		Game.Optimization.footstep_instances -= 1
		
	func _ready() -> void:
		self.play(texture)
		await self.animation_finished
		self.queue_free()
