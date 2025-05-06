class_name TimeManager
extends Node

const TIME_DREAM_ACCEL: int = 10
const TIME_REAL_ACCEL: int = 1
var acceleration: float = TIME_REAL_ACCEL

# ---- time ----
var time_hour: int = 0
var time_minute: int = 0

var minute_every_x_seconds = 15
var hour_every_x_minutes = 15

var time_elapsed_until_minute_increment: float

var total_seconds: int
var real_time_seconds_until_minute_increment: int = 5

func _ready() -> void:
	set_physics_process(false)

func setup() -> void: 
	time_hour = Time.get_time_dict_from_system().get("hour")
	time_minute = Time.get_time_dict_from_system().get("minute")
	total_seconds = (time_minute * 60) + (time_hour * 3600)
	
	set_physics_process(true)

func _process(delta: float) -> void:
	time_elapsed_until_minute_increment += delta
	
	if ((roundi(time_elapsed_until_minute_increment) % real_time_seconds_until_minute_increment) == 0 
		&& roundi(time_elapsed_until_minute_increment) != 0): 
		time_minute += 1
		total_seconds += 60
		time_elapsed_until_minute_increment = 0

		if (time_minute % 60) == 0:
			time_minute = 0
			time_hour += 1
			
			if time_hour > 24: 
				time_hour = 0
				total_seconds = 0

		
	#print("TIME (HH, MM): ", time_hour, " : ", time_minute)
	#print("TIME (SECONDS): ", total_seconds)
