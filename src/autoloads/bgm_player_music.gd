extends BGMPlayer

func _ready() -> void: 
	super()
	self.bus = "Music"
	fade_in()
