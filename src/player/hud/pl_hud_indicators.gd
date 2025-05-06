extends Control

@export var effect_ind: Control
@export var memoriam_ind: Control

@export var nosie_bar: ColorRect
@export var stamina_bar: ColorRect
@export var flames: ColorRect

var effect_equip_listener: EventListener
var effect_deequip_listener: EventListener

var memoriam_equip_listener: EventListener
var memoriam_deequip_listener: EventListener

var pl_stamina_change: EventListener
var pl_adrena_change: EventListener

func _ready() -> void:
	effect_equip_listener = EventListener.new(["PLAYER_EFFECT_EQUIP"], false, self)
	effect_deequip_listener = EventListener.new(["PLAYER_EFFECT_DEEQUIP"], false, self)
	
	effect_equip_listener.do_on_notify(func(): effect_ind.visible = true)
	effect_deequip_listener.do_on_notify(func(): effect_ind.visible = false)
	
	memoriam_equip_listener = EventListener.new(["PLAYER_MEMORIAM_EQUIP"], false, self)
	memoriam_deequip_listener = EventListener.new(["PLAYER_MEMORIAM_DEEQUIP"], false, self)	
	
	memoriam_equip_listener.do_on_notify(func(): memoriam_ind.visible = true)
	memoriam_deequip_listener.do_on_notify(func(): memoriam_ind.visible = false)
	
	# ----
	
	pl_stamina_change = EventListener.new(["PLAYER_STAMINA_CHANGE"], false, self)
	pl_adrena_change = EventListener.new(["PLAYER_ADRENALINE_CHANGE"], false, self)
	pl_stamina_change.do_on_notify(
		func(): 
			stamina_bar.size.x = 34 * GameManager.EventManager.get_event_param("PLAYER_STAMINA_CHANGE")[0] / Player.MAX_STAMINA)
	pl_adrena_change.do_on_notify(
		func(): 
			flames.self_modulate.a = GameManager.EventManager.get_event_param("PLAYER_ADRENALINE_CHANGE")[0] / 100)
		
