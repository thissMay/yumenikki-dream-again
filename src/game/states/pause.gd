extends State

@export var pause_menu: Control
@export var pause_bgm: BGM

func _ready() -> void:
	pause_bgm.autoplay = false

func enter_state() -> void: 
	GameManager.set_ui_visibility(false)
	
	pause_menu.visible = true
	pause_bgm.play_music()
	GameManager.set_cinematic_bars(true)
	Game.Application.pause()

func exit_state() -> void: 
	GameManager.set_ui_visibility(true)

	pause_menu.visible = false
	Music.play_music_dict(Music.prev_music)
	GameManager.set_cinematic_bars(false)
	Game.Application.resume()

func input(event: InputEvent, ) -> void:
	if Input.is_action_just_pressed("esc_menu"):
		if Game.is_paused: GameManager.pause_options(false)
