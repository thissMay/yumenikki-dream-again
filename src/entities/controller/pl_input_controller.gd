class_name InputController extends SentientController


func move(p: Player = PLInstance.player) -> void: 
	p.handle_velocity(Vector2(inp_x, inp_y), p.acceleration)
func interact(p: Player = PLInstance.player) -> void: 
	p.interaction_manager.handle_interaction()

func perform_action(p: Player = PLInstance.player) -> void: pass
