class_name DayNightModulate
extends CanvasModulate

const default_night_gradient: GradientTexture1D = preload("res://src/main/time/gradient.tres") 
var time_value: float
@export var day_night_gradient: GradientTexture1D = default_night_gradient 

func _physics_process(delta: float) -> void: pass
