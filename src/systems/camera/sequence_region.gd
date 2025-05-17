class_name SequenceRegion
extends Node

@export var enter_sequence: Sequence
@export var exit_sequence: Sequence

func _ready() -> void:
	var cam_region = get_parent()
	if cam_region != null and cam_region is CameraRegion:
		
		(cam_region as CameraRegion).area_entered.connect(
			func(_area: Area2D):
				if _area == PLInstance.get_pl().world_warp:
					if enter_sequence: enter_sequence.execute())
		
		(cam_region as CameraRegion).area_exited.connect(
			func(_area: Area2D):
				if _area == PLInstance.get_pl().world_warp:
					if exit_sequence: exit_sequence.execute())
