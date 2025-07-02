class_name FootstepTileMap
extends TileMapLayer

@export var ground_material: Footstep.mat
@export var custom_sound: AudioStream

func _use_tile_data_runtime_update(coords: Vector2i) -> bool:
	return get_cell_atlas_coords(coords) != null 
	
func _tile_data_runtime_update(coords: Vector2i, tile_data: TileData) -> void:
	tile_data.modulate = Color.TRANSPARENT
