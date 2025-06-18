class_name TimeManager
extends Component

static var instance

const TIME_DREAM_ACCEL: int = 10
const TIME_REAL_ACCEL: int = 1
var acceleration: float = TIME_REAL_ACCEL

# ---- time ----
var time_hour: int = 0
var time_minute: int = 0

var minute_every_x_seconds: int = 10
var hour_every_x_minutes: int = 6

var time_elapsed_until_minute_increment: float

var total_seconds: int

func _ready() -> void:
	instance = self
	set_physics_process(false)

func setup() -> void: 
	var real_global_hour = Time.get_time_dict_from_system().get("hour")
	var real_global_minute = Time.get_time_dict_from_system().get("minute")
	
	total_seconds = (
		(real_global_minute * minute_every_x_seconds) + 
		(real_global_hour * hour_every_x_minutes))
	
	time_minute = floori(total_seconds / minute_every_x_seconds)
	time_minute = floori(total_seconds / minute_every_x_seconds)
		
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	time_elapsed_until_minute_increment += delta
	update_minute(time_elapsed_until_minute_increment)


func update_minute(_elapsed: float) -> void:
	if roundi(_elapsed) > minute_every_x_seconds: 
		_elapsed = 0
