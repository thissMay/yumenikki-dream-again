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
	DIRT_FLESH 	= 10
	}
var curr_material: mat
const GROUND_MAT_DICT := {
	mat.NULL 		: preload("res://src/audio/footsteps/null.tres"),
	mat.CONCRETE 	: preload("res://src/audio/footsteps/concrete.tres"),
	mat.WOOD		: preload("res://src/audio/footsteps/wood.tres"),
	mat.SNOW 		: preload("res://src/audio/footsteps/snow.tres"),
	mat.GRASS 		: preload("res://src/audio/footsteps/grass.tres"),
	mat.MUD 		: preload("res://src/audio/footsteps/blood.tres"),
	mat.BLOOD 		: preload("res://src/audio/footsteps/blood.tres"),
	mat.WATER 		: preload("res://src/audio/footsteps/water.tres"),
	mat.CLOTH 		: preload("res://src/audio/footsteps/cloth.tres"),
	mat.GLASS 		: preload("res://src/audio/footsteps/glass.tres"),
	mat.DIRT_FLESH 	: preload("res://src/audio/footsteps/dirt_flesh.tres"),
	}

var DEFAULT_FOOTSTEP: AudioStreamWAV = preload("res://src/audio/se/footstep_null-1.wav")
var curr_anim: CompressedTexture2D = preload("res://src/entities/footsteps/default.png")

var footstep_se_player: SoundPlayer
var area: Area2D

var floor_priority: TileMapLayer
var greatest_index: int = -50

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

func initate_footstep() -> void:  
	var sounds_set: FootstepSet = GROUND_MAT_DICT[curr_material]
	
	curr_anim = sounds_set.footstep_anim
	spawn_footstep_fx()
	footstep_se_player.play_sound(
		sounds_set.pick_random() if sounds_set.size() > 0 else DEFAULT_FOOTSTEP, 
		clampf(-6 + log(sentient.get_noise()) * 6.25, -50, 1.5), 
		clampf(randf_range(0.75, sentient.get_noise()), 0.75, 1.2))		
func spawn_footstep_fx() -> void: 
	if Game.Optimization.footstep_instances < Game.Optimization.FOOTSTEP_MAX_INSTANCES:
		var footstep_fx := FootstepDust.new(curr_anim)
		self.add_child(footstep_fx)
		footstep_fx.global_position = sentient.global_position

func _on_body_shape_entered(
	body_rid: RID, 
	body: Node2D, 
	body_shape_index: int, 
	local_shape_index: int) -> void:
		
		if body is TileMapLayer:
			multiple_floors.append(body)
			
			for floors: TileMapLayer in multiple_floors.arr:
				if floors.z_index > greatest_index: 
					greatest_index = floors.z_index
					floor_priority = floors
					break
				
			var tile_coords: Vector2i = floor_priority.get_coords_for_body_rid(body_rid)
			var material_id: int = floor_priority.get_cell_tile_data(tile_coords).get_custom_data("material")
			curr_material = material_id
			
			if transparent_surfaces[curr_material]: sentient.shadow_renderer.visible = false
			else: sentient.shadow_renderer.visible = true
		else:
			sentient.shadow_renderer.visible = false
		
func _on_body_shape_exited(
	body_rid: RID, 
	body: Node2D, 
	body_shape_index: int, 
	local_shape_index: int) -> void:
		if body is TileMapLayer:
			
			if !area.overlaps_body(body):
				print(body ,": yo")
				multiple_floors.remove_at(multiple_floors.find(body)) 
				greatest_index = -50
				
				if  multiple_floors.is_empty():
					curr_material = default_footstep
					floor_priority = null
					greatest_index = -50
		
		
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
		self.play()
		await self.animation_finished
		self.queue_free()
