extends SentientState

var progress: float
var heading: float

func enter_state(s = null) -> void: 
	s.animation_manager.anim_state.start("walk")
	heading = s.get_dir()
func exit_state(s = null) -> void:
	s.animation_manager.anim_state.stop()
	
func update(_delta: float, s = null) -> void:
	heading = s.get_dir()
	s.animation_manager.update(s, _delta)
	s.animation_manager.anim_tree.set("parameters/tree/time_scale/scale", s.speed / s.max_speed)
	
func physics_update(_delta: float, s = null) -> void:
	s.get_behaviour()._climb(s)
