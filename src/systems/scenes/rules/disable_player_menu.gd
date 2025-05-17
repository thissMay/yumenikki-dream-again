extends SceneRule

# ---- virtual ----
func apply_on_scene_load() -> void: 
	GameManager.player_hud.show_ui(GameManager.player_hud, false)
func unapply_on_scene_unload() -> void:
	GameManager.player_hud.show_ui(GameManager.player_hud, true)
