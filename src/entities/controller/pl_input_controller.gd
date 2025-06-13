class_name InputController extends SentientController

func interact(_pl: Player = PLInstance.player) -> void: 
	_pl.interaction_manager.handle_interaction()
