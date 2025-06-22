extends LookAt

func _setup() -> void:
	look_at_target = Player.Instance.get_pl()
