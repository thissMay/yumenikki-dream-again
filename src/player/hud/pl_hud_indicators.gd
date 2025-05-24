extends Control

@export var effect_ind: SpriteSheetFormatter
@export var stamina_bar: ColorRect

var effect_equip: EventListener
var pl_stamina_change: EventListener

func _ready() -> void:
	effect_equip = EventListener.new(["PLAYER_EQUIP", "PLAYER_DEEQUIP"], false, self)
	effect_equip.do_on_notify("PLAYER_EQUIP", func(): effect_ind.progress = 1)
	effect_equip.do_on_notify("PLAYER_DEEQUIP", func(): effect_ind.progress = 0)
	
	# ----
	
	pl_stamina_change = EventListener.new(["PLAYER_STAMINA_CHANGE"], false, self)
	pl_stamina_change.do_on_notify(
		"PLAYER_STAMINA_CHANGE",
		func():
			stamina_bar.size.x = 29 * GameManager.EventManager.get_event_param("PLAYER_STAMINA_CHANGE")[0] / Player.MAX_STAMINA)

		
