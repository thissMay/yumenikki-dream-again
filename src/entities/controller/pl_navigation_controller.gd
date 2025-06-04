class_name NavigationController extends SentientController

var sprint: bool = false
var time_elapsed: float = 0

		
func move(p: Player = PLInstance.player) -> void:
	p.handle_velocity(Vector2(inp_x, inp_y), p.acceleration)
