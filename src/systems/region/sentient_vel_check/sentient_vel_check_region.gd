class_name SentientVelCheckRegion
extends Node

var sentient: SentientBase
var sentient_vel: Vector2
var sentient_dir: Entity.compass_headings
var area_region: AreaRegion

signal update

func _ready() -> void:
	area_region = get_parent()
	
	if area_region != null and area_region is AreaRegion:
		(area_region as AreaRegion).player_enter_handle.connect(func(_pl): 
			sentient = _pl
			set_process(true))
		(area_region as AreaRegion).player_exit_handle.connect(func(_pl):	
			sentient = null
			set_process(false))
	
	set_process(false)
func _process(delta: float) -> void:
	if sentient != null:
		sentient_vel = sentient.velocity
		sentient_dir = sentient.heading
		update.emit()
