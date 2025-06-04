extends LookAt

func setup() -> void:
	super()
	look_at_target = PLInstance.get_pl()
