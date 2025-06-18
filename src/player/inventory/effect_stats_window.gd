extends Control

@export var walk_speed: Control
@export var sprint_speed: Control
@export var sneak_speed: Control
@export var exhaust_speed: Control

@export var can_run: Control
@export var stamina_regen: Control
@export var stamina_decay: Control

@onready var default_player_stats := load("res://src/player/madotsuki/effects/_none/_default.tres")

@onready var stats_neutral_indicator := load("res://src/player/inventory/stats_neutral.png")
@onready var stats_positive_indicator := load("res://src/player/inventory/stats_positive.png")
@onready var stats_negative_indicator := load("res://src/player/inventory/stats_negative.png")

var player_stats_changed: EventListener

func _ready() -> void:
	player_stats_changed = EventListener.new(["PLAYER_EQUIP", "PLAYER_DEEQUIP"], false, self)
	player_stats_changed.do_on_notify("PLAYER_EQUIP", func(): update_stats_display(GameManager.EventManager.get_event_param("PLAYER_EQUIP")[0]))
	update_stats_display(PLInstance.get_pl().components.get_component_by_name("equip_manager").effect_data)
	
func update_stats_display(_effect: PLEffect) -> void:
		handle_stats_display_value(walk_speed, "WALK SPEED: %.2f m/s" % (_effect.stats.walk_multi * SentientBase.BASE_SPEED / 16))
		handle_stats_display_value(sprint_speed, "SPRINT SPEED: %.2f m/s" % (_effect.stats.sprint_multi * SentientBase.BASE_SPEED / 16))
		handle_stats_display_value(sneak_speed, "SNEAK SPEED: %.2f m/s" % (_effect.stats.sneak_multi * SentientBase.BASE_SPEED / 16))
		handle_stats_display_value(exhaust_speed, "EXHAUST SPEED: %.2f m/s" % (_effect.stats.exhaust_multi * SentientBase.BASE_SPEED / 16))
		
		handle_stats_display_value(can_run, "CAN RUN?: %s" % _effect.stats.can_run)
		handle_stats_display_value(stamina_regen, "STAMINA REGEN: +%.2f stam/s" % _effect.stats.stamina_regen)
		handle_stats_display_value(stamina_decay, "STAMINA DRAIN: -%.2f stam/s" % _effect.stats.stamina_drain)
		handle_stats_display_improvement(walk_speed, _effect.stats.walk_multi, default_player_stats.stats.walk_multi)
		handle_stats_display_improvement(sprint_speed, _effect.stats.sprint_multi, default_player_stats.stats.sprint_multi)
		handle_stats_display_improvement(sneak_speed, _effect.stats.sneak_multi, default_player_stats.stats.sneak_multi)
		handle_stats_display_improvement(exhaust_speed, _effect.stats.exhaust_multi, default_player_stats.stats.exhaust_multi)
				
		handle_stats_display_improvement(can_run, _effect.stats.can_run, default_player_stats.stats.can_run)
		handle_stats_display_improvement(stamina_regen, _effect.stats.stamina_regen, default_player_stats.stats.stamina_regen)
		handle_stats_display_improvement(stamina_decay, -_effect.stats.stamina_drain, -default_player_stats.stats.stamina_drain)
				

func handle_stats_display_value(_stat: Control, _text: String) -> void:
	if _stat.has_node("text"): _stat.get_node("text").text = str(_text)
	else: return
func handle_stats_display_improvement(_stat: Control, _value: float, _to_compare: float) -> void:
	if _stat.has_node("icon") and _stat.has_node("text"):
		if _value == _to_compare: 
			_stat.get_node("icon").texture = stats_neutral_indicator
			_stat.get_node("text").self_modulate = Color.WHITE
		elif _value > _to_compare: 
			_stat.get_node("icon").texture = stats_positive_indicator
			_stat.get_node("text").self_modulate = Color.GREEN_YELLOW
		elif _value < _to_compare: 
			_stat.get_node("icon").texture = stats_negative_indicator
			_stat.get_node("text").self_modulate = Color.RED
