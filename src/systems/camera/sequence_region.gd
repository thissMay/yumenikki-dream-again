class_name SequenceRegion
extends Node

@export var enter_sequence: Sequence
@export var exit_sequence: Sequence

func _ready() -> void:
	var area_region = get_parent()
	if area_region != null and area_region is AreaRegion:
		
		(area_region as AreaRegion).player_enter_handle.connect(
			func(_pl): if enter_sequence: 
				enter_sequence._execute())
		
		(area_region as AreaRegion).player_exit_handle.connect(
			func(_pl):	if exit_sequence: exit_sequence._execute())
